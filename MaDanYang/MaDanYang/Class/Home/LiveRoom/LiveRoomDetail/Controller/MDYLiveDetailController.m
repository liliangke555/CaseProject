//
//  MDYLiveDetailController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/24.
//

#import "MDYLiveDetailController.h"
#import <ZFPlayer/ZFPlayerControlView.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/UIImageView+ZFCache.h>
#import "MDYLiveMessageTableCell.h"
#import "MDYSendMeesageView.h"
#import "MDYShopView.h"
#import <TXLiteAVSDK_Professional/V2TXLivePlayer.h>
#import "MDYIMGenUserSigRequest.h"
#import <ImSDK/ImSDK.h>
@interface MDYLiveDetailController ()<UITableViewDelegate,UITableViewDataSource,TXLivePlayListener,V2TIMSDKListener,V2TIMAdvancedMsgListener>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;


@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIImageView *containerView;

@property (nonatomic, strong) TXLivePlayer *livePlayer;
@property (nonatomic, assign) TX_Enum_PlayType playType;
@end

@implementation MDYLiveDetailController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(KStatusBarHeight, 0, 0, 0));
        make.height.mas_equalTo(9/16.0f * CK_WIDTH);
    }];
    [self setupPlayer];
    [self createLeftButtonWithaboveSubview:self.containerView];
    [self createView];
    [self initIMSDK];
    [self loginIm];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![self startPlay]) {
        [MBProgressHUD showMessage:@"播放器启动失败"];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.livePlayer stopPlay];
}
- (void)setupPlayer {
}
- (BOOL)checkPlayUrl:(NSString*)playUrl {
    if ([playUrl hasPrefix:@"rtmp:"]) {
        _playType = PLAY_TYPE_LIVE_RTMP;
    } else if (([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]) && ([playUrl rangeOfString:@".flv"].length > 0)) {
        _playType = PLAY_TYPE_LIVE_FLV;
    } else if (([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]) && [playUrl rangeOfString:@".m3u8"].length > 0) {
        _playType = PLAY_TYPE_VOD_HLS;
    } else{
//        Alert(@"播放地址不合法，直播目前仅支持rtmp,flv播放方式!");
        
        return NO;
    }
    return YES;
}
- (BOOL)startPlay {
    NSString *playUrl = self.model.fivbofang;
    if (![self checkPlayUrl:playUrl]) {
        return NO;
    }
    [self.livePlayer setDelegate:self];
    [self.livePlayer setupVideoWidget:CGRectZero containView:self.containerView insertIndex:0];
    int ret = [self.livePlayer startPlay:playUrl type:_playType];
    if (ret != 0) {
//        Alert(@"播放器启动失败");
        return NO;
    }
    // 播放参数初始化
    //显示调试日志--调试模式下打开
    [self.livePlayer showVideoDebugLog:NO];//YES
//    [self setCacheStrategy:CACHE_STRATEGY_AUTO];  // 默认自动
    //竖屏直播模式
    [self.livePlayer setRenderRotation:HOME_ORIENTATION_DOWN];
    //图像铺满屏幕
    [self.livePlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
    return YES;
}

- (void)createView {
    UIImageView *headImageView = [[UIImageView alloc] init];
    [self.view addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_bottom).mas_offset(24);
        make.left.equalTo(self.view.mas_left).mas_offset(16);
        make.height.width.mas_equalTo(50);
    }];
    [headImageView setContentMode:UIViewContentModeScaleAspectFill];
    [headImageView.layer setCornerRadius:25];
    [headImageView setClipsToBounds:YES];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.model.head_portrait]];
    
    UILabel *titlelabel = [[UILabel alloc] init];
    [self.view addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).mas_offset(12);
        make.right.equalTo(self.view.mas_right).mas_offset(-12);
        make.top.equalTo(headImageView.mas_top);
    }];
    [titlelabel setText:self.model.live_title];
    [titlelabel setTextColor:K_TextBlackColor];
    [titlelabel setFont:KMediumFont(16)];
    
    UILabel *namelabel = [[UILabel alloc] init];
    [self.view addSubview:namelabel];
    [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).mas_offset(12);
        make.bottom.equalTo(headImageView.mas_bottom);
    }];
    [namelabel setText:self.model.name];
    [namelabel setTextColor:K_TextLightGrayColor];
    [namelabel setFont:KSystemFont(13)];
    
    UILabel *deslabel = [[UILabel alloc] init];
    [self.view addSubview:deslabel];
    [deslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_bottom).mas_offset(24);
        make.left.equalTo(self.view.mas_left).mas_offset(16);
        make.right.equalTo(self.view.mas_right).mas_offset(-16);
    }];
    [deslabel setText:self.model.introduction];
    [deslabel setTextColor:K_TextGrayColor];
    [deslabel setFont:KSystemFont(14)];
    
    UIView *lineView = [[UIView alloc] init];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
        make.top.equalTo(deslabel.mas_bottom).mas_offset(24);
        make.height.mas_equalTo(8);
    }];
    [lineView setBackgroundColor:KHexColor(0xF5F5F5FF)];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).mas_offset(12);
        make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, KBottomSafeHeight + 34 + 10, 0));
    }];
    
    MDYSendMeesageView *view = [[MDYSendMeesageView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    CKWeakify(self);
    [view setDidSendAction:^(NSString * _Nonnull string) {
        
        
        [[V2TIMManager sharedInstance] sendGroupTextMessage:string to:weakSelf.model.im_name priority:V2TIM_PRIORITY_DEFAULT succ:^{
            NSLog(@"----成功");
            [weakSelf.dataSource addObject:[NSString stringWithFormat:@"我：%@",string]];
            [weakSelf.tableView reloadData];
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
            [weakSelf.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        } fail:^(int code, NSString *desc) {
            NSLog(@"----失败");
        }];
        
    }];
    [view setShopAction:^{
        MDYShopView *view = [[MDYShopView alloc] init];
        [view show];
    }];
}
#pragma mark - Networking
- (void)loginIm {
    MDYIMGenUserSigRequest *request = [MDYIMGenUserSigRequest new];
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            MDYIMGenUserSigModel *model = response.data;
            [[V2TIMManager sharedInstance] login:model.uid userSig:model.userSig succ:^{
                [[V2TIMManager sharedInstance] getUsersInfo:@[model.uid] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
                    NSString *name = kUser.nickname;
                    V2TIMUserFullInfo *info = [[V2TIMUserFullInfo alloc] init];
                    info.nickName = name;
                    [[V2TIMManager sharedInstance] setSelfInfo:info succ:nil fail:nil];
                } fail:nil];
                [[V2TIMManager sharedInstance] joinGroup:weakSelf.model.im_name msg:@"" succ:^{
                    [[V2TIMManager sharedInstance] addAdvancedMsgListener:weakSelf];
                } fail:^(int code, NSString *desc) {
                }];
            } fail:^(int code, NSString *desc) {
                    
            }];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
    }];
}
- (void)initIMSDK {
    V2TIMSDKConfig *config = [[V2TIMSDKConfig alloc] init];
    config.logLevel = V2TIM_LOG_INFO;
    [[V2TIMManager sharedInstance] initSDK:1400530095 config:config listener:self];
}
- (void)loadMessage {
    
}
- (void)onRecvNewMessage:(V2TIMMessage *)msg {
    if (msg.isSelf) {
        [self.dataSource addObject:[NSString stringWithFormat:@"我：%@",msg.textElem.text]];
    } else {
        NSString *string = @"匿名";
        if (msg.nickName.length > 0) {
            string = msg.nickName;
        }
        [self.dataSource addObject:[NSString stringWithFormat:@"%@：%@",string,msg.textElem.text]];
    }
    [self.tableView reloadData];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
#pragma mark -
// 5. 监听 V2TIMSDKListener 回调
- (void)onConnecting {
    // 正在连接到腾讯云服务器
}
- (void)onConnectSuccess {
    // 已经成功连接到腾讯云服务器
}
- (void)onConnectFailed:(int)code err:(NSString*)err {
    // 连接腾讯云服务器失败
}
#pragma mark - TXLivePlayListener
/**
 * 直播事件通知
 * @param EvtID 参见 TXLiveSDKEventDef.h
 * @param param 参见 TXLiveSDKTypeDef.h
 */
- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param {
    NSLog(@"-%d--%@",EvtID,param);
}

/**
 * 网络状态通知
 * @param param 参见 TXLiveSDKTypeDef.h
 */
- (void)onNetStatus:(NSDictionary *)param {
    
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDYLiveMessageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYLiveMessageTableCell.class)];
    NSString *string = [self.dataSource objectAtIndex:indexPath.row];
    [cell.messageLabel setText:string];
    return cell;
}
#pragma mark - Getter
- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
        [_containerView setImageWithURLString:@"" placeholder:[UIImage ck_imageWithColor:KHexColor(0xDDDDDDFF)]];
    }
    return _containerView;
}
- (TXLivePlayer *)livePlayer {
    if (!_livePlayer) {
        _livePlayer = [[TXLivePlayer alloc] init];
        _livePlayer.enableHWAcceleration = YES;
        //        _livePlayer.config.connectRetryCount = 5;
        //        _livePlayer.config.connectRetryInterval = 5;
        //设置播放器代理
        _livePlayer.delegate = self;
    }
    return _livePlayer;
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = NO;
    }
    return _controlView;
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] init]];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYLiveMessageTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYLiveMessageTableCell.class)];
    }
    return _tableView;
}
@end
