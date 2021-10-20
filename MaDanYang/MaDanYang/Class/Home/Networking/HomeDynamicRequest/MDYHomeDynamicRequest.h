//
//  MDYHomeDynamicRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/23.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYHomeDynamicRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
AssignProperty NSInteger is_index;
AssignProperty NSInteger is_excellent;
@end

@interface MDYHomeDynamicModel : NSObject
CopyStringProperty drying_sheet_id;
CopyStringProperty nickname;
CopyStringProperty headimgurl;
CopyStringProperty txt;
StrongProperty NSArray*imgs;

CopyStringProperty car_time;
AssignProperty NSInteger integral_num;
AssignProperty BOOL is_thumbs_up;

@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
