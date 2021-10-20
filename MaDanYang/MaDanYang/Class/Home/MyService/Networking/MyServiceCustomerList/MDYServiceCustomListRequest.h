//
//  MDYServiceCustomListRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYServiceCustomListRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end

@interface MDYServiceCustomListModel : NSObject
CopyStringProperty name;
CopyStringProperty phone;
@end

NS_ASSUME_NONNULL_END
