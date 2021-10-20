//
//  MDYExternKey.h
//  MaDanYang
//
//  Created by kckj on 2021/7/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define CopyStringProperty  @property (copy, nonatomic) NSString *
#define StrongNumberProperty @property (strong, nonatomic) NSNumber *
#define AssignProperty @property (assign, nonatomic)
#define StrongProperty @property (strong, nonatomic)

//-- App Key
extern NSString *const MDYWechatAppID;
extern NSString *const MDYWechatAppSecret;
extern NSString *const MDYUniversalLink;

extern NSString *const MDYWechatOpenIDKey;
extern NSString *const MDYWechatAccessTokenKey;
extern NSString *const MDYWechatRefreshTokenKey;
extern NSString *const MDYWechatUserDataKey;

//-- 服务器 key
extern NSString *const ServerAddressWeb;

//-- 通知 key
extern NSString *const MDYWechatLoginSuccess;
extern NSString *const MDYWechatPaySuccess;
extern NSString *const MDYOrderChangeGoodsSuccess;


extern NSString *const MDYSingleKeyStringCurrentUser;
extern NSString *const kSingleKeyIsInputInformation;
extern NSString *const MDYTokenKey;


NS_ASSUME_NONNULL_END
