//
//  MDYOrderConfirmReceiptRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/24.
//

#import "MDYOrderConfirmReceiptRequest.h"

@implementation MDYOrderConfirmReceiptRequest
- (NSString *)uri{
    return @"api/MyOrder/confirm_receipt";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYOrderConfirmReceiptModel class];
}
@end

@implementation MDYOrderConfirmReceiptModel

@end
