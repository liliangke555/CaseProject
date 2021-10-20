//
//  MDYCourseVideoView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/23.
//

#import "MDYCourseVideoView.h"
@interface MDYCourseVideoView ()
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
@implementation MDYCourseVideoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.coverImageView];
        [self.coverImageView addSubview:self.playBtn];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    
    self.coverImageView.frame = self.bounds;
    
    min_w = 44;
    min_h = min_w;
    min_x = (CGRectGetWidth(self.coverImageView.frame)-min_w)/2;
    min_y = (CGRectGetHeight(self.coverImageView.frame)-min_h)/2;
    self.playBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
}

- (void)playBtnClick:(UIButton *)sender {
    if (self.playCallback) {
        self.playCallback();
    }
}

#pragma mark - getter

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"play_icon_44x44"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
//        _coverImageView.tag = kPlayerViewTag;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.image = [UIImage imageNamed:@"loading_bgView"];
    }
    return _coverImageView;
}
@end
