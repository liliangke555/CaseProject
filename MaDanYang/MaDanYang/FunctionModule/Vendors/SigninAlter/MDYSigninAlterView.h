//
//  MDYSigninAlterView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/10.
//

#import "MMPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYSigninAlterView : MMPopupView
- (instancetype)initWithImage:(MMPopupSetImageViewHandler)imageHandler title:(NSString *)title detail:(NSString *)detail button:(NSString *)buttonString didSelected:(void(^)(void))didSelected;
@end

NS_ASSUME_NONNULL_END
