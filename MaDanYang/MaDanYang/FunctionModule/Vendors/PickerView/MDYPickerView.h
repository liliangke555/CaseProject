//
//  MDYPickerView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/25.
//

#import "MMPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYPickerView : MMPopupView
- (instancetype)initWithTitle:(NSString *)title data:(NSArray <NSString *>*)data didSelected:(void(^)(NSInteger index,NSString *string))didSelected;
@end

NS_ASSUME_NONNULL_END
