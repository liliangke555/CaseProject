//
//  MDYBindPhone.m
//  MaDanYang
//
//  Created by kckj on 2021/7/9.
//

#import "MDYBindPhone.h"
#import "MDYUserModel.h"
@implementation MDYBindPhone
- (NSString *)uri{
    return @"api/Login/be_phone";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYBindPhoneModel class];
}
@end

@implementation MDYBindPhoneModel

@end
