//
//  MDYWechatPayRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/28.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYWechatPayRequest : MDYBaseRequest
CopyStringProperty order_num;
@end

@interface MDYWechatPayModel : NSObject
CopyStringProperty partnerid;
CopyStringProperty prepayid;
CopyStringProperty package;
CopyStringProperty timestamp;
CopyStringProperty appid;

CopyStringProperty noncestr;
CopyStringProperty sign;
@end

NS_ASSUME_NONNULL_END
