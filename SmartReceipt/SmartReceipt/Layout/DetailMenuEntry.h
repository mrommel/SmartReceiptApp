//
//  DetailMenuEntry.h
//  SmartReceipt
//
//  Created by Michael Rommel on 29.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailMenuEntry : NSObject

@property (retain) NSString *labelText;
@property NSInteger tag;

- (id) initWithLabelText:(NSString *)label andTag:(NSInteger)constant;

+ (DetailMenuEntry *)entryWithLabelText:(NSString *)label andTag:(NSInteger)constant;

@end
