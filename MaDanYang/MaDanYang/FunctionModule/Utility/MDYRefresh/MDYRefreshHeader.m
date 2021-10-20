//
//  MDYRefreshHeader.m
//  MaDanYang
//
//  Created by kckj on 2021/7/9.
//

#import "MDYRefreshHeader.h"
#import <Lottie/Lottie.h>
@interface MDYRefreshHeader()
@property (weak, nonatomic) LOTAnimationView *loading;
@end
@implementation MDYRefreshHeader

#pragma mark - 重写方法
- (void)prepare{
    [super prepare];
    // 设置控件的高度
    self.mj_h = 50;
    LOTAnimationView *loading = [LOTAnimationView animationWithFilePath:[[NSBundle mainBundle] pathForResource:@"lf20_RZPIuU" ofType:@"json"]];
    loading.loopAnimation = YES;
    loading.animationSpeed = 1.0f;
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews{
    [super placeSubviews];
    self.loading.frame = CGRectMake(0, 0, 30, 30);
    self.loading.center = CGPointMake(self.mj_w/2, self.mj_h * 0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];

}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stop];
            break;
        case MJRefreshStatePulling:
            [self.loading stop];
            break;
        case MJRefreshStateRefreshing:
            [self.loading play];
            break;
        case MJRefreshStateWillRefresh:
            [self.loading play];
            break;
        default:
            break;
    }
}

@end
