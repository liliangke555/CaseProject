//
//  MDYQuestionDetailAnswerTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/8.
//

#import <UIKit/UIKit.h>
#import "MDYPutQuestionInfoRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYQuestionDetailAnswerTableCell : UITableViewCell
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) void(^didToQuestion)(void);
@property (nonatomic, copy) void(^didCheckAnswer)(void);
@property (nonatomic, copy) void(^didCheckAnswerImage)(NSInteger index, NSArray *imageData, id view);

@property (nonatomic, strong) MDYPutQuestionInfoModel *infoModel;
@end

NS_ASSUME_NONNULL_END
