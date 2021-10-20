//
//  MDYLiveRoomLockView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/7.
//

#import "MMPopupView.h"
#import "MDYObsLiveListRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYLiveRoomLockView : MMPopupView
@property (nonatomic, copy) void(^didClickEnter)(NSString *string);
@property (nonatomic, strong) MDYObsLiveListModel *model;
@end

NS_ASSUME_NONNULL_END
