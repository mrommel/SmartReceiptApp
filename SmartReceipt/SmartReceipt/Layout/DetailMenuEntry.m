//
//  DetailMenuEntry.m
//  SmartReceipt
//
//  Created by Michael Rommel on 29.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import "DetailMenuEntry.h"

@implementation DetailMenuEntry

- (id) initWithLabelText:(NSString *)label andTag:(NSInteger)constant;
{
    self = [super init];
    if (self) {
        self.labelText = label;
        self.tag = constant;
    }
    
    return self;
}

+ (DetailMenuEntry *)entryWithLabelText:(NSString *)label andTag:(NSInteger)constant;
{
    return [[DetailMenuEntry alloc] initWithLabelText:label andTag:constant];
}

@end
