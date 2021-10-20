//
//  MDYSingleCache.h
//  MaDanYang
//
//  Created by kckj on 2021/6/11.
//

#import <Foundation/Foundation.h>
#import "MDYUserModel.h"


#define kUser [MDYSingleCache shareSingleCache].userModel
NS_ASSUME_NONNULL_BEGIN
@interface MDYSingleCache : NSObject
//创建单例对象
+ (instancetype)shareSingleCache;
+ (void)clean;

/**
 * 当前用户
 */
@property (nonatomic, strong, nullable) MDYUserModel *userModel;
@property (nonatomic, copy) NSString *token;
/**
 * 当前用户是否平台认证
 */
@property (nonatomic) BOOL isInputInformation;


@end

NS_ASSUME_NONNULL_END
