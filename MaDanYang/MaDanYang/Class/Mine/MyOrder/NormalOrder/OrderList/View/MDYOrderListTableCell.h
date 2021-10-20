//
//  MDYOrderListTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/16.
//

#import <UIKit/UIKit.h>
#import "MDYMyOrderListRequest.h"
#import "MDYIntegralOrderListRequest.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM (NSInteger) {
    MDYOrderTypeOfToPaid  = 0, //待付款
    MDYOrderTypeOfToDelivered  = 1, //待发货
    MDYOrderTypeOfToReceived     = 2, // 待收货
    MDYOrderTypeOfUnderReview     = 3, // 审核中
    MDYOrderTypeOfToFilledIn      = 4, // 待填写
    MDYOrderTypeOfRefuse      = 5, // 拒绝换货
    MDYOrderTypeOfCompleted      = 9, // 已完成
}MDYOrderType;
@interface MDYOrderListTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (nonatomic, assign) MDYOrderType orderTyp;
@property (nonatomic, copy) void(^didClickButton)(NSInteger index, MDYOrderType type);
@property (nonatomic, strong) MDYMyOrderListModel *orderModel;
@property (nonatomic, strong) MDYIntegralOrderListModel *integralModel;

@property (nonatomic, assign, getter=isGroupOrder) BOOL groupOrder;

@end

NS_ASSUME_NONNULL_END
