//
//  MDYMineHeaderView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/5.
//

#import "MDYMineHeaderView.h"
#import "MDYItemSubCollectionCell.h"

@interface MDYMineHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *integralLabel;
@end

@implementation MDYMineHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(CK_WIDTH);
            make.height.mas_equalTo(228);
        }];
        
        UIView *topView = [[UIView alloc] init];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self).insets(UIEdgeInsetsMake(12, 16, 0, 16));
            make.height.mas_equalTo(92);
        }];
        [topView setBackgroundColor:K_WhiteColor];
        [topView.layer setCornerRadius:6];
        [topView.layer setShadowColor:K_ShadowColor.CGColor];
        [topView.layer setShadowRadius:10.0f];
        [topView.layer setShadowOffset:CGSizeMake(0, 2)];
        [topView.layer setShadowOpacity:1.0f];
        [topView setClipsToBounds:YES];
        topView.layer.masksToBounds = NO;
        
        UIImageView *headerImageView = [[UIImageView alloc] init];
        [topView addSubview:headerImageView];
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView.mas_left).mas_offset(16);
            make.centerY.equalTo(topView.mas_centerY);
            make.width.height.mas_equalTo(60);
        }];
        [headerImageView.layer setCornerRadius:30];
        [headerImageView setContentMode:UIViewContentModeScaleAspectFill];
        [headerImageView setClipsToBounds:YES];
        [headerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHeader)]];
        headerImageView.userInteractionEnabled = YES;
        self.headerImageView = headerImageView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        [topView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerImageView.mas_right).mas_offset(16);
            make.top.equalTo(headerImageView.mas_top).mas_offset(4);
            make.right.equalTo(topView.mas_right).mas_offset(-40);
        }];
        [nameLabel setTextColor:K_TextBlackColor];
        [nameLabel setFont:KMediumFont(17)];
        [nameLabel setText:@"--"];
        nameLabel.userInteractionEnabled = YES;
        [nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHeader)]];
        self.nameLabel = nameLabel;
        
        UIImageView *integralImageView = [[UIImageView alloc] init];
        [topView addSubview:integralImageView];
        [integralImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headerImageView.mas_bottom).mas_offset(-4);
            make.left.equalTo(nameLabel.mas_left);
        }];
        UIImage *image = [[UIImage imageNamed:@"mine_integral_pop"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        [integralImageView setImage:image];
        integralImageView.userInteractionEnabled = YES;
        [integralImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickIntergral:)]];
        
        UILabel *integralLabel = [[UILabel alloc] init];
        [integralImageView addSubview:integralLabel];
        [integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(integralImageView).with.insets(UIEdgeInsetsMake(0, 10, 0, 20));
        }];
        [integralLabel setFont:KMediumFont(13)];
        [integralLabel setTextColor:K_WhiteColor];
        [integralLabel setText:@"0积分"];
        self.integralLabel = integralLabel;
        
        UIImageView *moreImageView = [[UIImageView alloc] init];
        [integralImageView addSubview:moreImageView];
        [moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(integralImageView.mas_right).mas_offset(-6);
            make.centerY.equalTo(integralLabel.mas_centerY);
        }];
        [moreImageView setImage:[UIImage imageNamed:@"mine_integral_more"]];
        
        UIButton *scanButton = [UIButton k_buttonWithTarget:self action:@selector(scanButtonAction:)];
        [topView addSubview:scanButton];
        [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(topView.mas_right).mas_offset(-16);
            make.centerY.equalTo(topView.mas_centerY);
        }];
        [scanButton setImage:[UIImage imageNamed:@"mine_scan_icon"] forState:UIControlStateNormal];
        
        UIView *bottomView = [[UIView alloc] init];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.top.equalTo(topView.mas_bottom).mas_equalTo(16);
            make.height.mas_equalTo(92);
        }];
        [bottomView setBackgroundColor:K_WhiteColor];
        [bottomView.layer setCornerRadius:6];
        [bottomView.layer setShadowColor:K_ShadowColor.CGColor];
        [bottomView.layer setShadowRadius:10.0f];
        [bottomView.layer setShadowOffset:CGSizeMake(0, 2)];
        [bottomView.layer setShadowOpacity:1.0f];
        [bottomView setClipsToBounds:YES];
        bottomView.layer.masksToBounds = NO;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(16, 0, 16, 0)];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:16];
        [flowLayout setItemSize:CGSizeMake((CK_WIDTH - 32) / 4.0f, 60)];
        [flowLayout setSectionHeadersPinToVisibleBounds:NO];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [bottomView addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(bottomView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [collectionView setBackgroundColor:K_WhiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYItemSubCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYItemSubCollectionCell.class)];
        [collectionView.layer setCornerRadius:6];
        [collectionView setClipsToBounds:YES];
        self.collectionView = collectionView;
    }
    return self;
}
#pragma mark - IBAction
- (void)scanButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickScan)]) {
        [self.delegate didClickScan];
    }
}
- (void)didClickHeader {
    if ([self.delegate respondsToSelector:@selector(didClickChangeInfo)]) {
        [self.delegate didClickChangeInfo];
    }
}
- (void)didClickIntergral:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickIntegral)]) {
        [self.delegate didClickIntegral];
    }
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((CK_WIDTH - 32) / 5.0f, 60);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYItemSubCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYItemSubCollectionCell.class) forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[indexPath.item];
    cell.title = dic[titleKey];
    cell.imageString = dic[imageKey];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.dataSource[indexPath.item];
    if ([self.delegate respondsToSelector:@selector(didSelectedItemWithString:)]) {
        [self.delegate didSelectedItemWithString:dic[titleKey]];
    }
}
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}
- (void)setHeaderIamgeUrl:(NSString *)headerIamgeUrl {
    _headerIamgeUrl = headerIamgeUrl;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerIamgeUrl] placeholderImage:[UIImage imageNamed:@"default_avatar_icon"]];
}
- (void)setUserModel:(MDYUserModel *)userModel {
    _userModel = userModel;
    if (userModel) {
        [self.nameLabel setText:userModel.nickname];
        [self.integralLabel setText:[NSString stringWithFormat:@"%@积分",userModel.integral]];
        self.headerIamgeUrl = userModel.headimgurl;
    }
}
@end
