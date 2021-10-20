//
//  MDYAllQuestionTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/8.
//

#import <UIKit/UIKit.h>
#import "MDYTypeInquestionRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYAllQuestionTableCell : UITableViewCell
@property (nonatomic, assign) BOOL isHight;
@property (nonatomic, copy) NSString *headerImageUrl;
@property (nonatomic, copy) void(^didToCheckAnswer)(void);
@property (nonatomic, strong) MDYTypeInquestionModel *questionModel;
@end

NS_ASSUME_NONNULL_END
