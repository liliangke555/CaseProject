//
//  MDYLiveRoomTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/7.
//

#import <UIKit/UIKit.h>
#import "MDYObsLiveListRequest.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM (NSInteger) {
    MDYLiveRoomOfLiving  = 0, //普通
    MDYLiveRoomOfLivingLock  = 1, //普通
    MDYLiveRoomOfNotice     = 2, // 拼团
    MDYLiveRoomOfNoticeNo     = 3, // 拼团
    MDYLiveRoomOfOver      = 4, // 秒杀
}MDYLiveRoomType;
@interface MDYLiveRoomTableCell : UITableViewCell
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) MDYLiveRoomType type;
@property (nonatomic, strong) MDYObsLiveListModel *listModel;
@property (nonatomic, copy) void(^didShowAction)(void);
@end

NS_ASSUME_NONNULL_END
