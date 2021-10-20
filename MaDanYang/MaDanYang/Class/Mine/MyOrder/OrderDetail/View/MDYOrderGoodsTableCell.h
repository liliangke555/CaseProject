//
//  MDYOrderGoodsTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/17.
//

#import <UIKit/UIKit.h>
#import "MDYOrderInfoReqeust.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYOrderGoodsTableCell : UITableViewCell
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) MDYOrderInfoGoodsModel *goodsModel;
@end

NS_ASSUME_NONNULL_END
