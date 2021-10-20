//
//  MDYMineHeaderView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/5.
//

#import <UIKit/UIKit.h>
#import "MDYUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol MDYMineHeaderDelegate <NSObject>

- (void)didClickScan;
- (void)didSelectedItemWithString:(NSString *)title;
- (void)didClickIntegral;
- (void)didClickChangeInfo;

@end

static NSString *titleKey = @"titleKey";
static NSString *imageKey = @"imageKey";
@interface MDYMineHeaderView : UIView
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) NSString *headerIamgeUrl;
@property (nonatomic, weak) id <MDYMineHeaderDelegate> delegate;
@property (nonatomic, strong) MDYUserModel *userModel;
@end

NS_ASSUME_NONNULL_END
