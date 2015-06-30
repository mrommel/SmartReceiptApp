//
//  ReceiptManager.m
//  SmartReceipt
//
//  Created by Michael Rommel on 19.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager ()

@property (strong, readwrite) NSManagedObjectContext *privateWriterContext;     // background writer MOC tied to the persistent store coordinator
@property (strong, readwrite) NSManagedObjectContext *mainContext;              // main thread MOC having privateWriterContext MOC as parent
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSURL *databaseURL;
@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, strong) NSString *coreDataStoreType;

- (NSURL *)applicationDocumentsDirectory;

@end

@implementation CoreDataManager

+ (CoreDataManager *)sharedInstance
{
    static CoreDataManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        [shared createManagedObjectContexts];
    });
    
    return shared;
}

#pragma mark - Public methods

- (NSManagedObjectContext *)createWorkerContext
{
    NSManagedObjectContext *workerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [workerContext setParentContext:self.mainContext];
    return workerContext;
}

- (NSManagedObject *)createNSManagedObjectForClass:(Class)entityClass
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(entityClass) inManagedObjectContext:self.mainContext];
}

- (void)saveContext
{
    [self saveMainContext];
}

- (void)saveObject:(NSManagedObject *)object
{
    if ([object hasChanges]) {
        [self saveContext:object.managedObjectContext];
    }
}

- (void)saveContext:(NSManagedObjectContext *)context
{
    [context performBlock:^{
        if ([context hasChanges]) {
            if ([context save:NULL]) {// save worker context
                if (context == self.mainContext) {
                    [self.privateWriterContext performBlock:^{
                        [self.privateWriterContext save:NULL];// write to disk
                    }];
                } else {
                    [self saveMainContext];
                }
            }
        }
    }];
}

- (void)deleteObject:(id)object
{
    NSManagedObjectContext *context = ((NSManagedObject *)object).managedObjectContext;
    [context performBlockAndWait:^{
        [context deleteObject:object];
        [self saveContext:context];
    }];
}

- (void)deleteObjects:(NSArray *)objects
{
    if ([objects count] == 0) {
        return;
    }
    NSManagedObjectContext *context = ((NSManagedObject *)objects[0]).managedObjectContext;
    [context performBlockAndWait:^{
        for (NSManagedObject *obj in objects) {
            [context deleteObject:obj];
        }
        [self saveContext:context];
    }];
}

- (NSArray *)dataWithFetchRequest:(NSFetchRequest *)request error:(NSError **)error
{
    __block NSArray	*results = nil;
    [self.mainContext performBlockAndWait:^{
        results = [self.mainContext executeFetchRequest:request error:error];
    }];
    return results;
}

- (void)dataWithFetchRequest:(NSFetchRequest *)request completionBlock:(FetchResponseBlock)block
{
    __block NSArray	*results = nil;
    __block NSError *errorObj = nil;
    [self.mainContext performBlock:^{
        results = [self.mainContext executeFetchRequest:request error:&errorObj];
        block(results, errorObj);
    }];
}

- (void)rollback
{
    [self.mainContext performBlock:^{
        [self.mainContext rollback];
    }];
}

- (NSManagedObject *)managedObject:(NSManagedObject *)object inContext:(NSManagedObjectContext *)context
{
    __block NSManagedObject *managedObject = nil;
    [context performBlockAndWait:^{
        managedObject = [context objectWithID:[object objectID]];
    }];
    return managedObject;
}

#pragma mark - Core Data stack

/*
 * Returns the managed object model for the application.
 * If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SmartReceipt" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

-(NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

-(NSString *)dataStorePath {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"ReceiptStore.sqlite"];
}

/*
 * Returns the persistent store coordinator for the application.
 * If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [NSURL fileURLWithPath:[self dataStorePath]];
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSError *error;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // TODO: Handle the error appropriately
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
    
    return _persistentStoreCoordinator;
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
}

#pragma mark - Private methods

- (void)createManagedObjectContexts
{
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        // Create the background writer NSManagedObjectContext with concurrency type NSPrivateQueueConcurrenyType
        self.privateWriterContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [self.privateWriterContext setPersistentStoreCoordinator:coordinator];
        // Create the main thread NSManagedObjectContext with the concurrency type to NSMainQueueConcurrencyType
        self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [self.mainContext setParentContext:self.privateWriterContext];
    }
}

- (void)saveMainContext
{
    [self.mainContext performBlock:^{
        if ([self.mainContext hasChanges]) {
            if ([self.mainContext save:NULL]) {// save main thread context
                [self.privateWriterContext performBlock:^{
                    [self.privateWriterContext save:NULL];// write to disk
                }];
            }
        }
    }];
}

@end
