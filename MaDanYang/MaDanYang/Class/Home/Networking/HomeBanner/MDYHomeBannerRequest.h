//
//  MDYHomeBannerRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/9.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYHomeBannerRequest : MDYBaseRequest

@end

@interface MDYHomeBannerModel : NSObject
CopyStringProperty uid;
CopyStringProperty typeid;
CopyStringProperty img;
CopyStringProperty url;
CopyStringProperty miaoshu;
@end

NS_ASSUME_NONNULL_END
