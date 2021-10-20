//
//  MDYServiceMessageRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYServiceMessageRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
@end

@interface MDYServiceMessageModel : NSObject
CopyStringProperty uid;
CopyStringProperty name;
CopyStringProperty phone;
CopyStringProperty txt;
CopyStringProperty txt_admin;

CopyStringProperty creation_time;

CopyStringProperty is_show;
AssignProperty CGFloat messageHeagit;
@end

NS_ASSUME_NONNULL_END
