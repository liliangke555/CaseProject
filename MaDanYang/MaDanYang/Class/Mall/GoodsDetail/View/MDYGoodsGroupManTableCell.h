//
//  MDYGoodsGroupManTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/22.
//

#import <UIKit/UIKit.h>
#import "MDYMyGoodsGroupRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYGoodsGroupManTableCell : UITableViewCell
@property (nonatomic, strong) MDYMyGoodsGroupListModel *model;
@property (nonatomic, copy) void(^didJoinGroup)(MDYMyGoodsGroupModel *model);
@end

NS_ASSUME_NONNULL_END
