//
//  MDYBaseRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/8.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN
#define RequestMethodGet  @"GET"
#define RequestMethodPut  @"PUT"
#define RequestMethodDelete  @"DELETE"
#define RequestMethodPOST  @"POST"

@class MDYBaseRequest;
@class MDYBaseResponse;

typedef void (^RequestCompletionHandler)(MDYBaseResponse *response);

@interface MDYBaseRequest : NSObject {
@protected
    MDYBaseResponse            *_response;
    RequestCompletionHandler _succHandler;
    RequestCompletionHandler _failHandler;
}

@property (strong, nonatomic)AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) MDYBaseResponse *response;
@property (nonatomic, copy) RequestCompletionHandler succHandler;
@property (nonatomic, copy) RequestCompletionHandler failHandler;

@property (nonatomic, assign) BOOL isRequestParametersMethodJson;
@property (nonatomic, assign) BOOL hideLoadingView;


- (NSString *)uri;

- (NSString *)requestMethod;

- (NSData *)toPostData;

- (Class)responseDataClass;

- (void)parseResponse:(NSObject *)respJsonObject;

// 异步请求Req
- (void)asyncRequestWithsuccessHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail;

- (void)asyncRequestWithFormDatas:(NSArray<NSData *> *)formDatas formName:(NSString *)formName successHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail;

- (void)asyncRequestWithVoiceData:(NSData *)data formName:(NSString *)formName successHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail;


- (void)uploadWitImagedData:(NSData *)imageData
                 uploadName:(NSString *)uploadName
                   progress:(void (^)(NSProgress *progress))progress
             successHandler:(RequestCompletionHandler)succHandler failHandler:(RequestCompletionHandler)fail;

+ (void)wechatLoginGetOpenIDWithCode:(NSString *)code
                        successBlock:(void(^)(NSDictionary * _Nullable result))successBlock
failureBlock:(void(^)(NSError * _Nullable error))failureBlock;

@end

@interface MDYBaseResponse : NSObject

@property (assign, nonatomic) NSInteger code;//用来判断请求成功与否 0请求成功 >0请求失败 <0网络连接失败

@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *status; //SUCCESSS  fail

@property (strong, nonatomic) id data;

- (BOOL)success;

@end

NS_ASSUME_NONNULL_END
