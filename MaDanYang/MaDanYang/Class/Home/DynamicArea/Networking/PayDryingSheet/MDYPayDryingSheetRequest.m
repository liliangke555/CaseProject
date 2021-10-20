//
//  MDYPayDryingSheetRequest.m
//  MaDanYang
//
//  Created by kckj on 2021/8/20.
//

#import "MDYPayDryingSheetRequest.h"

@implementation MDYPayDryingSheetRequest
- (NSString *)uri{
    return @"api/DryingSheet/paydryingSheet";
}
- (NSString *)requestMethod
{
    return @"POST";
}
- (Class)responseDataClass{
    return [MDYPayDryingSheetModel class];
}
@end

@implementation MDYPayDryingSheetModel

@end
