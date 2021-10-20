//
//  MDYShopView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/24.
//

#import "MDYShopView.h"
#import "MDYSearchResultTableCell.h"
@interface MDYShopView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MDYShopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = K_WhiteColor;
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        self.type = MMPopupTypeSheet;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(CK_HEIGHT - 88);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        UIView *topView = [[UIView alloc] init];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).mas_offset(-6);
            make.left.right.equalTo(self).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(12);
        }];
        [topView setBackgroundColor:K_WhiteColor];
        [topView.layer setCornerRadius:6];
        [topView setClipsToBounds:YES];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        
        UIButton *backButton = [UIButton mm_buttonWithTarget:self action:@selector(backAction:)];
        [self addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(16);
            make.left.equalTo(self.mas_left).mas_offset(16);
        }];
        [backButton setTitle:@"  返回" forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
        [backButton setTitleColor:K_TextBlackColor forState:UIControlStateNormal];
        [backButton.titleLabel setFont:KSystemFont(16)];
        lastAttribute = backButton.mas_bottom;
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.top.equalTo(lastAttribute).mas_offset(10);
        }];
    }
    return self;
}
- (void)backAction:(UIButton *)sender {
    [self hide];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 124;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDYSearchResultTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYSearchResultTableCell.class)];
    cell.type = indexPath.row % 3;
    cell.money = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.imageUrl = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fn.sinaimg.cn%2Fsinakd20112%2F1%2Fw1440h961%2F20200709%2Fdbe3-iwasyei5207863.jpg&refer=http%3A%2F%2Fn.sinaimg.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1625977575&t=e4482b6db85d58c6dcf33257aab716be";
    cell.hiddenNote = indexPath.row % 3 != 0;
    cell.noteString = @"1.3万已购买";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 16)]];
        [_tableView setBackgroundColor:K_WhiteColor];
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYSearchResultTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYSearchResultTableCell.class)];
    }
    return _tableView;
}
@end
