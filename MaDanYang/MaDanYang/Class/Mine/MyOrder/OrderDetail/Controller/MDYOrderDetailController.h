//
//  MDYOrderDetailController.h
//  MaDanYang
//
//  Created by kckj on 2021/6/17.
//

#import "CKBaseViewController.h"
#import "MDYOrderListTableCell.h"
NS_ASSUME_NONNULL_BEGIN
@interface MDYOrderDetailController : CKBaseViewController
@property (nonatomic, assign) MDYOrderType orderType;
@property (nonatomic, copy) NSString *orderNum;
@property (nonatomic, assign, getter=isGroupOrder) BOOL groupOrder;
@end

NS_ASSUME_NONNULL_END
