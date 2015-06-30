//
//  CoreDataReceiptManager.h
//  SmartReceipt
//
//  Created by Michael Rommel on 19.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoreDataManager.h"

@class Receipt;

@interface CoreDataReceiptManager : NSObject

+ (CoreDataReceiptManager *)sharedInstance;

- (BOOL)saveReceipt;
- (BOOL)addReceiptWithTitle: (NSString *)title;
- (NSArray *)getAllReceipts;
- (Receipt *)getReceiptForId:(NSNumber *)identifier;
- (BOOL)deleteReceipt: (Receipt *)receiptToDelete;

@end
