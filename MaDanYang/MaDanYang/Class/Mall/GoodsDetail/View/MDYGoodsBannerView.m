//
//  MDYGoodsBannerView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/22.
//

#import "MDYGoodsBannerView.h"

@interface MDYGoodsBannerView ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleView;
@property (nonatomic, strong) UILabel *numLabel;
@end
@implementation MDYGoodsBannerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(CK_WIDTH);
        make.height.mas_equalTo(216);
    }];
    
    SDCycleScrollView *cycleView = [[SDCycleScrollView alloc] init];
    [self addSubview:cycleView];
    [cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    cycleView.delegate = self;
    cycleView.infiniteLoop = YES;
    cycleView.autoScrollTimeInterval = 5.0f;
//    cycleView.imageURLStringsGroup = ;
    cycleView.showPageControl = NO;
    cycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.cycleView = cycleView;
    
    UIView *numView = [[UIView alloc] init];
    [self addSubview:numView];
    [numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).mas_offset(-16);
        make.bottom.equalTo(self.mas_bottom).mas_offset(-12);
        make.height.mas_equalTo(25);
    }];
    [numView.layer setCornerRadius:12.5];
    [numView setBackgroundColor:KHexColor(0x00000067)];
    [numView setClipsToBounds:YES];
    
    UILabel *numLabel = [[UILabel alloc] init];
    [numView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(numView).with.insets(UIEdgeInsetsMake(4, 12, 4, 12));
    }];
    [numLabel setTextColor:K_WhiteColor];
    [numLabel setFont:KSystemFont(12)];
    self.numLabel = numLabel;
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"---点击了第%ld张图片", (long)index);
    if (self.didClickImage) {
        self.didClickImage(cycleScrollView,index);
    }
}
 
// 滚动到第几张图回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
//    NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
    [self.numLabel setText:[NSString stringWithFormat:@"%ld/%ld",index+1,self.imageArray.count]];
}
#pragma mark - Setter
- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    [self.numLabel setText:[NSString stringWithFormat:@"1/%ld",imageArray.count]];
    self.cycleView.imageURLStringsGroup = imageArray;
}
@end
