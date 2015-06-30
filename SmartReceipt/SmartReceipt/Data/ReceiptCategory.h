//
//  Category.h
//  SmartReceipt
//
//  Created by Michael Rommel on 19.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ReceiptCategory : NSManagedObject

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSString *title;


@end
