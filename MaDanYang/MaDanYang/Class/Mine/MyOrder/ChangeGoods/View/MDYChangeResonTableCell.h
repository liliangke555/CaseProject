//
//  MDYChangeResonTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYChangeResonTableCell : UITableViewCell
@property (nonatomic, copy) void(^didEndEditingString)(NSString *string);
@end

NS_ASSUME_NONNULL_END
