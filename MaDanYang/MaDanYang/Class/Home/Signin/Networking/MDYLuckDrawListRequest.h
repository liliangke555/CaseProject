//
//  MDYLuckDrawListRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/9/14.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYLuckDrawListRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end

@interface MDYLuckDrawListModel : NSObject
StrongProperty NSArray *luck_drawlistlist;
@end

NS_ASSUME_NONNULL_END
