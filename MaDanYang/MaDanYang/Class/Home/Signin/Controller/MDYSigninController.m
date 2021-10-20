//
//  MDYSigninController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/10.
//

#import "MDYSigninController.h"
#import "MDYSigninAlterView.h"
#import "MDYLuckListRequest.h"
#import "MDYLuckDrawlRequest.h"
#import "MDYLuckDrawListRequest.h"
@interface MDYSigninController ()<CAAnimationDelegate>{
    dispatch_group_t _group;
}
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, assign) NSInteger circleAngle;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *luckLabels;
@property (nonatomic, strong) MDYLuckListModel *luckModel;

@property (nonatomic, strong) NSMutableArray *luckRecordLabels;
@end

@implementation MDYSigninController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"签到";
    _group = dispatch_group_create();
    self.luckRecordLabels = [NSMutableArray array];
    [self initView];
    [self getLuckListData];
    [self getLuckListRecordData];
}
- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Networking
- (void)getLuckListData {
    MDYLuckListRequest *request = [MDYLuckListRequest new];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            weakSelf.dataSource = response.data;
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)getLuckListRecordData {
    MDYLuckDrawListRequest *request = [MDYLuckDrawListRequest new];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            MDYLuckDrawListModel *model = response.data;
            if (model.luck_drawlistlist.count > 0) {
                UILabel *label = weakSelf.luckRecordLabels[0];
                [label setText:model.luck_drawlistlist[0]];
            }
            if (model.luck_drawlistlist.count > 1) {
                UILabel *label = weakSelf.luckRecordLabels[1];
                [label setText:model.luck_drawlistlist[1]];
            }
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)getLuckId {
    MDYLuckDrawlRequest *request = [MDYLuckDrawlRequest new];
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            weakSelf.luckModel = response.data;
        } else {
            weakSelf.luckModel = nil;
        }
        dispatch_group_leave(self->_group);
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        weakSelf.luckModel = nil;
        dispatch_group_leave(self->_group);
    }];
}
#pragma mark - Setter
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    if (dataSource) {
        for (int i = 0; i < dataSource.count; i ++) {
            UILabel *label = self.luckLabels[i];
            MDYLuckListModel *model = dataSource[i];
            [label setText:model.luck_draw_name];
        }
    }
}
#pragma mark 初始化View
-(void)initView{
    [self.view setBackgroundColor:KHexColor(0x8FD6F5FF)];
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.mas_equalTo(44 + KStatusBarHeight);
    }];
    
    UIButton *backButton = [UIButton k_buttonWithTarget:self action:@selector(backButtonAction:)];
    [topView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).mas_offset(12);
        make.bottom.equalTo(topView.mas_bottom);
    }];
    [backButton setTitle:@"  返回" forState:UIControlStateNormal];
    [backButton setTitleColor:K_WhiteColor forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigation_white"] forState:UIControlStateNormal];
    [backButton.titleLabel setFont:KSystemFont(16)];
    
    UILabel *titlelabel = [[UILabel alloc] init];
    [topView addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(topView.mas_centerX);
            make.centerY.equalTo(backButton.mas_centerY);
    }];
    [titlelabel setText:@"签到"];
    [titlelabel setTextColor:K_WhiteColor];
    [titlelabel setFont:KMediumFont(17)];
    
    UIImageView *topbackImageView = [[UIImageView alloc] init];
    [self.view insertSubview:topbackImageView atIndex:0];
    [topbackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).mas_offset(-32);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    [topbackImageView setImage:[UIImage imageNamed:@"signin_top_bg"]];
    
    UIImageView *bottomImageView = [[UIImageView alloc] init];
    [self.view addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view).insets(UIEdgeInsetsZero);
        make.height.mas_equalTo(CK_HEIGHT / 2.0f -115);
    }];
    [bottomImageView setImage:[[UIImage imageNamed:@"signin_bottom_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(100, 187.5, 95, 187.5) resizingMode:UIImageResizingModeStretch]];
    
    UIImageView *titleView = [[UIImageView alloc] init];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).mas_offset(40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(188);
        make.height.mas_equalTo(46);
    }];
    [titleView setImage:[UIImage imageNamed:@"signin_titlebg_icon"]];
    
    UIImageView *titleView1 = [[UIImageView alloc] init];
    [self.view addSubview:titleView1];
    [titleView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).mas_offset(38);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(188);
        make.height.mas_equalTo(46);
    }];
    [titleView1 setImage:[UIImage imageNamed:@"signin_title_icon"]];
    
    //转盘背景
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 317,317)];
    _bgImageView.center = self.view.center;
    _bgImageView.image = [UIImage imageNamed:@"signin_turntable_bg"];
    [self.view addSubview:_bgImageView];
    
    //添加GO按钮图片
    UIImageView *btnimage = [[UIImageView alloc]initWithFrame:CGRectMake(CK_WIDTH/2-41.5, CK_HEIGHT/2-48, 83, 90)];
    btnimage.image = [UIImage imageNamed:@"signin_go_icon"];
    [self.view addSubview:btnimage];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    label.center = CGPointMake(CGRectGetWidth(btnimage.frame) / 2.0f, CGRectGetHeight(btnimage.frame) / 2.0f);
    [label setText:@"点击\n抽奖"];
    [label setNumberOfLines:0];
    [label setTextColor:K_TextMoneyColor];
    [label setFont:KBoldFont(16)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [btnimage addSubview:label];
    
    
    _bgImageView.userInteractionEnabled = YES;
    btnimage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick)];
    [btnimage addGestureRecognizer:tap];
    
    //添加文字
    NSArray *_prizeArray = @[@"--",@"--",@"--",@"--",@"--",@"--",@"--",@"--"];
    
    for (int i = 0; i < 8; i ++) {
        
        UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,100,CGRectGetHeight(_bgImageView.frame)/2)];
        labelView.layer.anchorPoint = CGPointMake(0.5, 1.0);
        labelView.center = CGPointMake(CGRectGetHeight(_bgImageView.frame)/2, CGRectGetHeight(_bgImageView.frame)/2);
        CGFloat angle = M_PI*2/8 * i;
        labelView.transform = CGAffineTransformMakeRotation(angle);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 56,80,50)];
//        label.layer.anchorPoint = CGPointMake(0.5, 1.0);
//        label.center = CGPointMake(CGRectGetHeight(_bgImageView.frame)/2, CGRectGetHeight(_bgImageView.frame)/2);
        label.text = [NSString stringWithFormat:@"%@", _prizeArray[i]];
        label.textColor = K_TextMoneyColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:12];
//        CGFloat angle = M_PI*2/8 * i;
//        label.transform = CGAffineTransformMakeRotation(angle);
        [label setNumberOfLines:0];
        
        [self.luckLabels addObject:label];
        
        [labelView addSubview:label];
        [_bgImageView addSubview:labelView];
        
    }
    
    UIImageView *manImageView = [[UIImageView alloc] init];
    [self.view addSubview:manImageView];
    [manImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bgImageView.mas_bottom).mas_offset(54);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    [manImageView setImage:[[UIImage imageNamed:@"signin_man_icon"] resizableImageWithCapInsets:UIEdgeInsetsMake(254, 186, 254, 186) resizingMode:UIImageResizingModeStretch]];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    [self.view addSubview:noteLabel];
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(manImageView.mas_bottom);
        make.height.mas_equalTo(28);
    }];
    [noteLabel setText:@"·每天签到可以获得一次抽奖机会"];
    [noteLabel setFont:KSystemFont(14)];
    [noteLabel setTextColor:K_WhiteColor];
    
    MASViewAttribute *lastAttribute = noteLabel.mas_bottom;
    for (int i = 0; i < 2; i ++) {
        UIImageView *winbgView = [[UIImageView alloc] init];
        [self.view addSubview:winbgView];
        [winbgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(292);
            make.height.mas_equalTo(48);
        }];
        [winbgView setImage:[UIImage imageNamed:@"signin_win_bg"]];
        
        UILabel *winLabel = [[UILabel alloc] init];
        [winbgView addSubview:winLabel];
        [winLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(winbgView.mas_centerX);
            make.top.bottom.left.right.equalTo(winbgView).insets(UIEdgeInsetsMake(0, 5, 5, 5));
        }];
        [winLabel setText:@"恭喜XXXX用户获得1000积分奖励"];
        [winLabel setFont:KSystemFont(14)];
        [winLabel setNumberOfLines:0];
        [winLabel setTextColor:K_WhiteColor];
        lastAttribute = winbgView.mas_bottom;
        [self.luckRecordLabels addObject:winLabel];
    }
}

#pragma mark 点击Go按钮
-(void)btnClick{
    
    NSLog(@"点击Go");
    
    //判断是否正在转
    if (_isAnimation) {
        return;
    }
    _isAnimation = YES;

    [self getLuckId];

    
    CKWeakify(self);
    dispatch_group_notify(self->_group, dispatch_get_main_queue(), ^{
        
        if (!weakSelf.luckModel) {
            weakSelf.isAnimation = NO;
            return;
        }
        
        //控制概率[0,80)
        NSInteger lotteryPro = 0;
        for (int i = 0; i < weakSelf.dataSource.count; i ++) {
            MDYLuckListModel *model = weakSelf.dataSource[i];
            if ([model.luck_draw_id isEqualToString:weakSelf.luckModel.luck_draw_id]) {
                lotteryPro = i;
                break;
            }
        }
        
        //设置转圈的圈数
        NSInteger circleNum = 6;
        
        if (lotteryPro == 0) {
            weakSelf.circleAngle = 0;
        }else if (lotteryPro == 7){
            weakSelf.circleAngle = 45;
        }else if (lotteryPro == 6){
            weakSelf.circleAngle = 90;
        }else if (lotteryPro == 5){
            weakSelf.circleAngle = 135;
        }else if (lotteryPro == 4){
            weakSelf.circleAngle = 180;
        }else if (lotteryPro == 3){
            weakSelf.circleAngle = 225;
        }else if (lotteryPro == 2){
            weakSelf.circleAngle = 270;
        }else if (lotteryPro == 1){
            weakSelf.circleAngle = 315;
        }
        
        CGFloat perAngle = M_PI/180.0;
        
        NSLog(@"turnAngle = %ld",(long)weakSelf.circleAngle);
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:weakSelf.circleAngle * perAngle + 360 * perAngle * circleNum];
        rotationAnimation.duration = 5.0f;
        rotationAnimation.cumulative = YES;
        rotationAnimation.delegate = self;
        
        
        //由快变慢
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        rotationAnimation.fillMode=kCAFillModeForwards;
        rotationAnimation.removedOnCompletion = NO;
        [weakSelf.bgImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
}
#pragma mark 动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    _isAnimation = NO;
    NSLog(@"动画停止");
    NSString *title;
    NSInteger i = 0;
    if (_circleAngle == 0) {
        i = 0;
    }else if (_circleAngle == 45){
        i = 7;
    }else if (_circleAngle == 90){
        i = 6;
    }else if (_circleAngle == 135){
        i = 5;
    }else if (_circleAngle == 180){
        i = 4;
    }else if (_circleAngle == 225){
        i = 3;
    }else if (_circleAngle == 270){
        i = 2;
    }else if (_circleAngle == 315){
        i = 1;
    }
    MDYLuckListModel *model = self.dataSource[i];
//    title = model.luck_draw_name;
//    NSString *string = @"";
//    if ([title isEqualToString:@"谢谢惠顾"]) {
//        string = [NSString stringWithFormat:@"%@\n再接再厉",title];
//    } else {
//        string = [NSString stringWithFormat:@"获得%@奖品\n请到积分商城查看详细",title];
//    }
    MDYSigninAlterView *view = [[MDYSigninAlterView alloc] initWithImage:^(UIImageView *imageView) {
        [imageView setImage:[[UIImage imageNamed:@"signin_alter_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(120, 150, 180, 150) resizingMode:UIImageResizingModeStretch]];
    } title:@"恭喜你" detail:model.luck_draw_name  button:@"返回" didSelected:^{
    }];
    [view show];
}
- (NSMutableArray *)luckLabels {
    if (!_luckLabels) {
        _luckLabels = [NSMutableArray array];
    }
    return _luckLabels;
}
@end
