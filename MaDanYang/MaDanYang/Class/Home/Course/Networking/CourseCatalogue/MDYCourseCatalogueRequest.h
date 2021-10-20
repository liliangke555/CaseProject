//
//  MDYCourseCatalogueRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/10.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYCourseCatalogueRequest : MDYBaseRequest
AssignProperty NSInteger c_id;
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end
@interface MDYCourseCatalogueModel : NSObject
CopyStringProperty uid;
CopyStringProperty c_id;
CopyStringProperty name;
CopyStringProperty video_src;
CopyStringProperty sort;
@end
NS_ASSUME_NONNULL_END
