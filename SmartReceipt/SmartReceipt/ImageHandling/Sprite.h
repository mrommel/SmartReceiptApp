//
//  Sprite.h
//  SmartReceipt
//
//  Created by Michael Rommel on 30.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Sprite : NSObject

- (id)initWithFilename:(NSString *)imageFileName andTiles:(CGSize)size;

- (UIImage *)imageForIndex:(NSInteger)index;

+ (Sprite *)spriteNamed:(NSString *)imageFileName andTiles:(CGSize)size;

@end
