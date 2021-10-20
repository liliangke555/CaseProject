//
//  MDYLivePlayBackController.m
//  MaDanYang
//
//  Created by kckj on 2021/9/15.
//

#import "MDYLivePlayBackController.h"
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "MDYCourseVideoView.h"
@interface MDYLivePlayBackController ()
@property (nonatomic, strong) MDYCourseVideoView *videoView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end

@implementation MDYLivePlayBackController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}
- (BOOL)shouldAutorotate {
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player stop];
    self.player.viewControllerDisappear = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:KHexColor(0x000000CC)];
    if (self.isNotice > 0) {
        self.navigationItem.title = @"直播预告";
    } else {
        self.navigationItem.title = @"直播回放";
    }
    
    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.videoView];
    self.player.playerDisapperaPercent = 1.0;
    self.player.playerApperaPercent = 0.0;
    self.player.stopWhileNotVisible = NO;
    CGFloat margin = 20;
    CGFloat w = CK_WIDTH/2;
    CGFloat h = w * 9/16;
    CGFloat x = CK_WIDTH - w - margin;
    CGFloat y = CK_HEIGHT - h - margin;
    self.player.smallFloatView.frame = CGRectMake(x, y, w, h);
    self.player.controlView = self.controlView;
    
    @zf_weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        kAPPDelegate.allowOrentitaionRotation = isFullScreen;
    };
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @zf_strongify(self)
        [self.player stopCurrentPlayingView];
    };
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.videoView.center = CGPointMake(CK_WIDTH / 2.0f, CGRectGetHeight(self.view.frame) / 2.0f);
}
/// 播放试看视频
- (void)playVideo {
    
    if (self.luboString.length <=0) {
        [MBProgressHUD showMessage:@"暂无可播放视频"];
        return;
    }
    self.player.currentPlayerManager.assetURL = [NSURL URLWithString:self.luboString];
    [self.controlView showTitle:@"" coverURLString:@"" fullScreenMode:ZFFullScreenModeAutomatic];
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.prepareShowLoading = YES;
    }
    return _controlView;
}
- (MDYCourseVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[MDYCourseVideoView alloc] init];
        _videoView.frame = CGRectMake(0, 0, CK_WIDTH, 9/16.0 * CK_WIDTH);
        [self.view addSubview:_videoView];
        CKWeakify(self);
        [_videoView setPlayCallback:^{
            [weakSelf playVideo];
        }];
    }
    return _videoView;
}
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self playVideo];
//}
@end
