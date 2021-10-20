//
//  MDYImageCollectionCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import "MDYImageCollectionCell.h"

@interface MDYImageCollectionCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBottomHeight;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, copy) void(^didClickDelete)(void);
@end

@implementation MDYImageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.layer setCornerRadius:4];
    [self setClipsToBounds:YES];
    self.deleteButton.hidden = YES;
}
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    if ([imageUrl hasPrefix:@"http"]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    } else {
        [self.imageView setImage:[UIImage imageNamed:imageUrl]];
    }
    
}
- (void)showDelete:(BOOL)showDelete deleteAction:(void (^)(void))deleteAction {
    if (showDelete) {
        self.deleteButton.hidden = NO;
        self.didClickDelete = deleteAction;
    } else {
        self.deleteButton.hidden = YES;
    }
}
- (IBAction)deleteButtonAction:(UIButton *)sender {
    if (self.didClickDelete) {
        self.didClickDelete();
    }
}
@end
