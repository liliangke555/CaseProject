//
//  ZPickerView.h
//  ZhiBaiYi
//
//  Created by kckj on 2020/12/4.
//

#import "MMPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZPickerView : MMPopupView
- (instancetype)initWithTitle:(NSString *)title data:(NSArray <NSString *>*)data didSelected:(void(^)(NSString *string))didSelected;
@end

NS_ASSUME_NONNULL_END
