//
//  MDYQuestionDetailView.h
//  MaDanYang
//
//  Created by kckj on 2021/6/8.
//

#import <UIKit/UIKit.h>
#import "MDYPutQuestionInfoRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYQuestionDetailView : UIView
//@property (nonatomic, strong) MDYQuestionDetail *model;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) void(^reviewImageView)(NSInteger index, NSArray *imageData);
@property (nonatomic, strong) MDYPutQuestionInfoModel *infoModel;
@end

NS_ASSUME_NONNULL_END
