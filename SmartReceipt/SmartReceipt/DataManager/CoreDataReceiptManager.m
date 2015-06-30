//
//  CoreDataReceiptManager.m
//  SmartReceipt
//
//  Created by Michael Rommel on 19.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import "CoreDataReceiptManager.h"

#import "Receipt.h"
#import "Receipt+Extended.h"

@interface CoreDataReceiptManager()

@property (nonatomic, strong) NSArray *allReceipts;

@end

@implementation CoreDataReceiptManager

#pragma mark - Constructor

+ (CoreDataReceiptManager *)sharedInstance;
{
    static CoreDataReceiptManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

#pragma mark - Save ManagedObjects

- (BOOL)saveReceipt
{
    [[CoreDataManager sharedInstance] saveContext];
    NSLog(@"Receipt saved");
    return YES;
}

- (BOOL)addReceiptWithTitle: (NSString *)title
{
    Receipt *receiptObject = (Receipt *)[[CoreDataManager sharedInstance] createNSManagedObjectForClass:[Receipt class]];
    [receiptObject setTitle:title];
    [receiptObject setImage:[UIImage imageNamed:@"receipt.png"]];
    
    [[CoreDataManager sharedInstance] saveObject:receiptObject];
    return YES;
}

- (NSArray *)getAllReceipts;
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Receipt class])];
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user.userID == %@", userID]];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortByName]];
    self.allReceipts = [[CoreDataManager sharedInstance] dataWithFetchRequest:fetchRequest error:NULL];
    
    return self.allReceipts;
}

- (Receipt *)getReceiptForId:(NSNumber *)identifier
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Receipt class])];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", identifier]];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortByName]];
    NSArray *receipts = [[CoreDataManager sharedInstance] dataWithFetchRequest:fetchRequest error:NULL];
    
    return receipts && receipts.count > 0 ? [receipts lastObject] : nil;
}

- (BOOL)deleteReceipt: (Receipt *)receiptToDelete
{
    [[CoreDataManager sharedInstance] deleteObject:receiptToDelete];
    return YES;
}

@end
