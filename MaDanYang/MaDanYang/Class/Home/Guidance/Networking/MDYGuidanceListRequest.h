//
//  MDYGuidanceListRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/5.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYGuidanceListRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end

@interface MDYGuidanceListModel : NSObject
CopyStringProperty post_id;
CopyStringProperty usename;
CopyStringProperty img;
CopyStringProperty title;
CopyStringProperty cartime;
@end

NS_ASSUME_NONNULL_END
