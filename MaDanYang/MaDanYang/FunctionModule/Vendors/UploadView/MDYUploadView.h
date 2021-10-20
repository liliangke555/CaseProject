//
//  MDYUploadView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/21.
//

#import "MMPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYUploadView : MMPopupView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) void(^didToUpload)(void);
@end

NS_ASSUME_NONNULL_END
