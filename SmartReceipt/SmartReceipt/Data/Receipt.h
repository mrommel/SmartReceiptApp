//
//  Receipt.h
//  SmartReceipt
//
//  Created by Michael Rommel on 19.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface Receipt : NSManagedObject

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSData *imageData;

@end
