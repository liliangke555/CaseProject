//
//  MDYTitleView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYTitleView : UICollectionReusableView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) void(^didClickButton)(void);
@end

NS_ASSUME_NONNULL_END
