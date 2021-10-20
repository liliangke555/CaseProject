//
//  MDYHomeDynamicRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/7/23.
//

#import "MDYHomeDynamicRequest.h"

@implementation MDYHomeDynamicRequest
- (NSString *)uri{
    return @"api/DryingSheet/indexdryingSheetList";
}
- (NSString *)requestMethod
{
    return @"GET";
}
- (Class)responseDataClass{
    return [MDYHomeDynamicModel class];
}
@end

@implementation MDYHomeDynamicModel

- (void)setTxt:(NSString *)txt {
    _txt = txt;
    CGFloat height = [txt getLabelHeightWithWidth:CK_WIDTH - 32 - 24 font:14];
    _cellHeight  += height > 51 ? 51 : height;
}
- (void)setImgs:(NSArray *)imgs {
    _imgs = imgs;
    if (imgs.count > 0) {
        _cellHeight += (CK_WIDTH - 32 - 24 - 24) / 4.0f;
    } else {
    }
}

@end
