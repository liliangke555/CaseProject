//
//  MDYOrderDetailButtonTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYOrderDetailButtonTableCell : UITableViewCell
@property (nonatomic, copy) void(^didClickButton)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
