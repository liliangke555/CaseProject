//
//  MDYGetQRCodeRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/10.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYGetQRCodeRequest : MDYBaseRequest

@end

@interface MDYGetQRCodeModel : NSObject
CopyStringProperty url;
@end

NS_ASSUME_NONNULL_END
