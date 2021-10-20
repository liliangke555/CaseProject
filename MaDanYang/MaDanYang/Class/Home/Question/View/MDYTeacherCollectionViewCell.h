//
//  MDYTeacherCollectionViewCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/7.
//

#import <UIKit/UIKit.h>
#import "MDYTeacherListRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYTeacherCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *headerImageUrl;
@property (nonatomic, copy) void(^didCheckBlock)(void);
@property (nonatomic, copy) void(^didToQuestionBlock)(void);
@property (nonatomic, strong) MDYTeacherListModel *teacherModel;
@end

NS_ASSUME_NONNULL_END
