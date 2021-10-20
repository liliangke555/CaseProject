//
//  MDYOrderAddressTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/16.
//

#import <UIKit/UIKit.h>
#import "MDYPlaceOrderRequest.h"
#import "MDYOrderInfoReqeust.h"
#import "MDYIntergralOrderRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYOrderAddressTableCell : UITableViewCell
@property (nonatomic, strong) MDYPlaceOrderAddressModel *addressModel;
@property (nonatomic, strong) MDYOrderInfoAddressModel *infoAddressModel;

@property (nonatomic, strong) MDYIntergralOrderAddressModel *integralAddressModel;
@end

NS_ASSUME_NONNULL_END
