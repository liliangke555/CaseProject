//
//  MDYCourseVideoView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYCourseVideoView : UIView
//@property (nonatomic, strong) ZFTableData *data;
@property (nonatomic, strong, readonly) UIImageView *coverImageView;

@property (nonatomic, copy) void(^playCallback)(void);
@end

NS_ASSUME_NONNULL_END
