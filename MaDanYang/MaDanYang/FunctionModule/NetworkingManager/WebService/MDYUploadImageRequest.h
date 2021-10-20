//
//  MDYUploadImageRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/10.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYUploadImageRequest : MDYBaseRequest

@end

@interface MDYUploadImageModel : NSObject
CopyStringProperty url;
@end

NS_ASSUME_NONNULL_END
