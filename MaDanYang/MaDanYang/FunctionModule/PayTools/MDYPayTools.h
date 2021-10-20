//
//  MDYPayTools.h
//  MaDanYang
//
//  Created by kckj on 2021/7/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYPayTools : NSObject
/// 微信支付
/// @param dicData 支付信息
/// @param completion 支付结果
+ (void)kcPayWithWXDicData:(NSDictionary *)dicData completion:(void (^ __nullable)(BOOL success))completion;

/// 支付宝支付
/// @param stringSigned 支付签名信息（后台获取）
/// @param completion 支付结果
+ (void)kcPayWithZFBStringSigned:(NSString *)stringSigned completion:(void (^ __nullable)(NSDictionary *resultDic))completion;
@end

NS_ASSUME_NONNULL_END
