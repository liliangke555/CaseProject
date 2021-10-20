//
//  MDYHomeQuestionsCollectionCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import <UIKit/UIKit.h>
#import "MDYHomeQuestionRequest.h"
#import "MDYQuestionAnswerAreaRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYHomeQuestionsCollectionCell : UICollectionViewCell
@property (nonatomic, copy) NSString *headerImageUrl;
@property (nonatomic, copy) void(^didToCheckAnswer)(void);
@property (nonatomic, strong) MDYHomeQuestionModel *homeQuestionModel;
@property (nonatomic, strong) MDYQuestionAnswerAreaModel *answerModel;
@end

NS_ASSUME_NONNULL_END
