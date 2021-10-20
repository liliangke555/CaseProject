//
//  MDYPayTools.m
//  MaDanYang
//
//  Created by kckj on 2021/7/28.
//

#import "MDYPayTools.h"
#import <WechatOpenSDK/WXApi.h>
#import <AlipaySDK/AlipaySDK.h>
@implementation MDYPayTools
/// 微信支付
/// @param dicData 支付信息
/// @param completion 支付结果
+ (void)kcPayWithWXDicData:(NSDictionary *)dicData completion:(void (^ __nullable)(BOOL success))completion {
    // 判断是否安装微信
    if ([WXApi isWXAppInstalled] ) {
        //判断当前微信的版本是否支持OpenApi
        if ([WXApi isWXAppSupportApi]) {
        }else{
            [MBProgressHUD showMessage:@"请升级微信至最新版本！"];
            return;
        }
    }else{
        [MBProgressHUD showMessage:@"您未安装微信客户端"];
        return;
    }
    //从后台获取支付订单信息
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = dicData[@"partnerid"];
    request.prepayId = dicData[@"prepayid"];
    request.package = dicData[@"package"];
    request.nonceStr = dicData[@"noncestr"];
    int intTimeStamp = [dicData[@"timestamp"] intValue];
    request.timeStamp = (UInt32)intTimeStamp;
    request.sign = dicData[@"sign"];
    [WXApi sendReq:request completion:^(BOOL success) {
        if (completion) {
            completion(success);
        }
    }];
}
/// 支付宝支付
/// @param stringSigned 支付签名信息（后台获取）
/// @param completion 支付结果
+ (void)kcPayWithZFBStringSigned:(NSString *)stringSigned completion:(void (^ __nullable)(NSDictionary *resultDic))completion {
    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
    NSString *appScheme = @"mdyalipaysdk";
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:stringSigned fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if (completion) {
            completion(resultDic);
        }
    }];
}
@end
