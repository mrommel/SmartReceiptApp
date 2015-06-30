//
//  Receipt+Entended.m
//  SmartReceipt
//
//  Created by Michael Rommel on 24.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import "Receipt+Extended.h"

@implementation Receipt (Extended)

- (void)setImage:(UIImage *)image {
    NSData* imageDataValue = UIImagePNGRepresentation(image);
    self.imageData = imageDataValue;
}

- (UIImage *)getImage {
    return [UIImage imageWithData:self.imageData];
}

@end
