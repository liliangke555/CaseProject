//
//  MDYLivePlayBackController.h
//  MaDanYang
//
//  Created by kckj on 2021/9/15.
//

#import "CKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYLivePlayBackController : CKBaseViewController
@property (nonatomic, copy) NSString *luboString;
@property (nonatomic, assign, getter=isNotice) BOOL notice;
@end

NS_ASSUME_NONNULL_END
