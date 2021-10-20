//
//  NSString+MDYStringSize.h
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MDYStringSize)
- (CGFloat)getLabelHeightWithWidth:(CGFloat)width font: (CGFloat)font;

- (CGFloat)getWidthWithHeight:(CGFloat)height font:(CGFloat)font;
- (CGFloat)getSpaceLabelHeightwithAttrDict:(NSMutableDictionary *)dict withWidth:(CGFloat)width;

- (NSString *)changeHtmlString;
@end

NS_ASSUME_NONNULL_END
