//
//  ReceiptManager.h
//  SmartReceipt
//
//  Created by Michael Rommel on 19.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^FetchResponseBlock)(NSArray *result, NSError *error);

@interface CoreDataManager : NSObject

@property (strong, readonly) NSManagedObjectContext *mainContext;            // main thread MOC
@property (strong, readonly) NSManagedObjectContext *privateWriterContext;   // PSC writer background thread MOC

+ (CoreDataManager *)sharedInstance;

// Creation methods
- (NSManagedObjectContext *)createWorkerContext;
- (NSManagedObject *)createNSManagedObjectForClass:(Class)entityClass;
// Save methods
- (void)saveContext;
- (void)saveObject:(NSManagedObject *)object;
// Delete methods
- (void)deleteObject:(NSManagedObject *)object;
- (void)deleteObjects:(NSArray *)objects;
// Fetch data methods
- (NSArray *)dataWithFetchRequest:(NSFetchRequest *)request error:(NSError **)error;
- (void)dataWithFetchRequest:(NSFetchRequest *)request completionBlock:(FetchResponseBlock)block;
// Reset data
- (void)rollback;
// Convert the given object to the given context
- (NSManagedObject *)managedObject:(NSManagedObject *)object inContext:(NSManagedObjectContext *)context;


@end
