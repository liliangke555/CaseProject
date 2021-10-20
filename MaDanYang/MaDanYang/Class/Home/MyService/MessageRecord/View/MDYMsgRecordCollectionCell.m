//
//  MDYMsgRecordCollectionCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/11.
//

#import "MDYMsgRecordCollectionCell.h"

@interface MDYMsgRecordCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UILabel *replyNewLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MDYMsgRecordCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setBackgroundColor:K_WhiteColor];
    [self.layer setCornerRadius:6];
    [self.layer setShadowColor:K_ShadowColor.CGColor];
    [self.layer setShadowRadius:10.0f];
    [self.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.layer setShadowOpacity:1.0f];
    [self setClipsToBounds:YES];
    self.layer.masksToBounds = NO;
    
    [self.replyView.layer setCornerRadius:4];
    [self.replyView setClipsToBounds:YES];
}
- (void)setModel:(MDYServiceMessageModel *)model {
    _model = model;
    if (model) {
        [self.messageLabel setText:model.txt];
//        self.timeLabel setText:mod
        [self.replyLabel setText:model.txt_admin];
        [self.timeLabel setText:model.creation_time];
        if ([model.is_show integerValue] == 0) {
            self.replyView.hidden = NO;
        } else {
            self.replyView.hidden = YES;
        }
    }
}
@end
