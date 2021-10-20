//
//  MDYLiveMessageTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYLiveMessageTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

NS_ASSUME_NONNULL_END
