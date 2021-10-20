//
//  UIColor+CKColorSet.m
//  CloudKind
//
//  Created by kckj on 2021/5/11.
//

#import "UIColor+CKColorSet.h"

@implementation UIColor (CKColorSet)
+ (UIColor *)k_colorWithHex:(NSUInteger)hex
{
    
    float r = (hex & 0xff000000) >> 24;
    float g = (hex & 0x00ff0000) >> 16;
    float b = (hex & 0x0000ff00) >> 8;
    float a = (hex & 0x000000ff);
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}
@end
