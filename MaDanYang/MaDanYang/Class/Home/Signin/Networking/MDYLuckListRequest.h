//
//  MDYLuckListRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/29.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYLuckListRequest : MDYBaseRequest

@end

@interface MDYLuckListModel : NSObject
CopyStringProperty luck_draw_id;
CopyStringProperty luck_draw_name;
@end

NS_ASSUME_NONNULL_END
