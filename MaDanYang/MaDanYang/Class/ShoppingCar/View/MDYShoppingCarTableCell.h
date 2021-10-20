//
//  MDYShoppingCarTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import <UIKit/UIKit.h>
#import "MDYShoppingCarListRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYShoppingCarTableCell : UITableViewCell
@property (nonatomic, copy) void(^didChangeNum)(NSInteger num);
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) NSInteger selectedNum;
@property (nonatomic, strong) MDYShoppingCarListModel *listModel;
@end

NS_ASSUME_NONNULL_END
