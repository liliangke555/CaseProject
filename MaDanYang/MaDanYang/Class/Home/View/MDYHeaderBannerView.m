//
//  MDYHeaderBannerView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import "MDYHeaderBannerView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
@interface MDYHeaderBannerView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleView;
@end
@implementation MDYHeaderBannerView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(CK_WIDTH);
    }];
    SDCycleScrollView *cycleView = [[SDCycleScrollView alloc] init];
    [self addSubview:cycleView];
    [cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
    cycleView.delegate = self;
    cycleView.infiniteLoop = YES;
    cycleView.autoScrollTimeInterval = 5.0f;
    cycleView.showPageControl = NO;
    [cycleView.layer setCornerRadius:6];
    [cycleView setClipsToBounds:YES];
    cycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.cycleView = cycleView;
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"---点击了第%ld张图片", (long)index);
    if (self.didSelectedIndex) {
        self.didSelectedIndex(index);
    }
}
 
// 滚动到第几张图回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
//    NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
}

#pragma mark - Setter
- (void)setHomeImageModels:(NSArray *)homeImageModels {
    _homeImageModels = homeImageModels;
    NSMutableArray *array = [NSMutableArray array];
    for (MDYHomeBannerModel *model in homeImageModels) {
        [array addObject:model.img];
    }
    self.cycleView.imageURLStringsGroup = array;
}
@end
