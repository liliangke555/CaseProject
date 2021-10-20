//
//  MDYUploadAppRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/9/15.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYUploadAppRequest : MDYBaseRequest

@end

@interface MDYUploadAppDetailModel : NSObject
CopyStringProperty version;
CopyStringProperty link;
CopyStringProperty update;
@end

@interface MDYUploadAppModel : NSObject
StrongProperty MDYUploadAppDetailModel *ios;
@end

NS_ASSUME_NONNULL_END
