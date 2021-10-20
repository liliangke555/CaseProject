//
//  MDYSingleCache.m
//  MaDanYang
//
//  Created by kckj on 2021/6/11.
//

#import "MDYSingleCache.h"
@implementation MDYSingleCache
@synthesize isInputInformation = _isInputInformation;
@synthesize userModel = _userModel;
@synthesize token = _token;
//创建单例对象
+ (instancetype)shareSingleCache {
    
    static MDYSingleCache *singleCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleCache = [[MDYSingleCache alloc] init];
    });
    return singleCache;
}
+ (void)clean {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dict = [userDefaults dictionaryRepresentation];
    
    for (id key in dict) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
}

- (MDYUserModel *)userModel {
    if (!_userModel) {
        NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] valueForKey:MDYSingleKeyStringCurrentUser];
        if (userDic) {
            _userModel = [[MDYUserModel alloc] mj_setKeyValues:userDic];
        }
    }
    return _userModel;
}

- (void)setUserModel:(MDYUserModel *)userModel {
    if (!userModel) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:MDYSingleKeyStringCurrentUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (_userModel != userModel) {
        _userModel = userModel;
        [[NSUserDefaults standardUserDefaults] setValue:[_userModel mj_keyValues] forKey:MDYSingleKeyStringCurrentUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BOOL)isInputInformation {
    _isInputInformation = [[NSUserDefaults standardUserDefaults] boolForKey:kSingleKeyIsInputInformation];
    return _isInputInformation;
}
- (void)setIsInputInformation:(BOOL)isInputInformation {
    _isInputInformation = isInputInformation;
    [[NSUserDefaults standardUserDefaults] setValue:@(_isInputInformation) forKey:kSingleKeyIsInputInformation];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)token {
    _token = [[NSUserDefaults standardUserDefaults] objectForKey:MDYTokenKey];
    return _token;
}
- (void)setToken:(NSString *)token {
    _token = token;
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:MDYTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
