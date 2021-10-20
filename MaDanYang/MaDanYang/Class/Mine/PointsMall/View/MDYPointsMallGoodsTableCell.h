//
//  MDYPointsMallGoodsTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/15.
//

#import <UIKit/UIKit.h>
#import "MDYIntegralGoodsListRequest.h"
#import "MDYIntegralCourseListReqeust.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYPointsMallGoodsTableCell : UITableViewCell
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, strong) MDYIntegralGoodsListModel *goodsModel;
@property (nonatomic, strong) MDYIntegralCourseListModel *courseModel;
@end

NS_ASSUME_NONNULL_END
