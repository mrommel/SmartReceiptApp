//
//  Sprite.m
//  SmartReceipt
//
//  Created by Michael Rommel on 30.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import "Sprite.h"

@interface Sprite() {
    UIImage *_image;
    CGSize _size;
}

@end

@implementation Sprite

- (id)initWithFilename:(NSString *)imageFileName andTiles:(CGSize)size
{
    self = [super init];
    
    if (self) {
        _size = size;
        _image = [UIImage imageNamed:imageFileName];
    }
    
    return self;
}

- (UIImage *)imageForIndex:(NSInteger)index
{
    if (_image) {
        CGSize imageSize = _image.size;
        CGSize tileSize = CGSizeMake(imageSize.width / _size.width, imageSize.height / _size.height);
        
        // TODO add proper index calculation
        NSInteger positionX = (index % (int)_size.width) * tileSize.width;
        NSInteger positionY = (index / (int)_size.width) * tileSize.height;
        
        CGImageRef spriteSheet = [_image CGImage];
        CGImageRef sprite = CGImageCreateWithImageInRect(spriteSheet, CGRectMake(positionX, positionY, tileSize.width, tileSize.height));
        return [UIImage imageWithCGImage:sprite];
    }
    
    return nil;
}

+ (Sprite *)spriteNamed:(NSString *)imageFileName andTiles:(CGSize)size
{
    return [[Sprite alloc] initWithFilename:imageFileName andTiles:size];
}

@end
