//
//  MDYInputInfoTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYInputInfoTableCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^didEndEditingString)(NSString *string);
@end

NS_ASSUME_NONNULL_END
