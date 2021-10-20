//
//  UIImage+CKImageSet.m
//  CloudKind
//
//  Created by kckj on 2021/5/11.
//

#import "UIImage+CKImageSet.h"

@implementation UIImage (CKImageSet)
+ (UIImage *) ck_imageWithColor:(UIColor *)color
{
    return [UIImage ck_imageWithColor:color Size:CGSizeMake(4.0f, 4.0f)];
}

+ (UIImage *) ck_imageWithColor:(UIColor *)color Size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image ck_stretched];
}

- (UIImage *) ck_stretched
{
    CGSize size = self.size;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(truncf(size.height-1)/2, truncf(size.width-1)/2, truncf(size.height-1)/2, truncf(size.width-1)/2);
    
    return [self resizableImageWithCapInsets:insets];
}
@end
