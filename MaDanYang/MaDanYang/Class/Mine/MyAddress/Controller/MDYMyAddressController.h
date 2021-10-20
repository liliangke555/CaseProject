//
//  MDYMyAddressController.h
//  MaDanYang
//
//  Created by kckj on 2021/6/21.
//

#import "CKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MDYMyaddressDeleaget <NSObject>

/// 选择地址回调
/// @param data 回调数据
- (void)didSelectedAddress:(NSDictionary *)data;

@end

@interface MDYMyAddressController : CKBaseViewController
@property (nonatomic, weak) id <MDYMyaddressDeleaget> delegate;
@end

NS_ASSUME_NONNULL_END
