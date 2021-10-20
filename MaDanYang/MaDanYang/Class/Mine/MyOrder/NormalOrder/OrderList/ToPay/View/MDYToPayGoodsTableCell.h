//
//  MDYToPayGoodsTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/16.
//

#import <UIKit/UIKit.h>
#import "MDYPlaceOrderRequest.h"
#import "MDYIntergralOrderRequest.h"
#import "MDYCoursePreviewOrderRequest.h"
#import "MDYOrderInfoReqeust.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYToPayGoodsTableCell : UITableViewCell
@property (nonatomic, copy) void(^didChangeNum)(NSInteger num);
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) NSInteger selectedNum;
@property (nonatomic, assign, getter=isCourse) BOOL course;

@property (nonatomic, strong) MDYPlaceOrderGoodsModel *goodsModel;
@property (nonatomic, strong) MDYIntergralOrderGoodsModel *integralGoodModel;
@property (nonatomic, strong) MDYCurriculumDetailModel *courseModel;

@property (nonatomic, strong) MDYOrderInfoGoodsModel *orderGoodsModel;
@end

NS_ASSUME_NONNULL_END
