//
//  MDYGoodsDetailTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/8/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYGoodsDetailTableCell : UITableViewCell
@property (nonatomic, copy) NSString *htmlString;
@property (nonatomic, copy) void(^didReloadView)(void);
@end

NS_ASSUME_NONNULL_END
