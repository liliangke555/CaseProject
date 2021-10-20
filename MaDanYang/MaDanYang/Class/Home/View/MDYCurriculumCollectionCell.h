//
//  MDYCurriculumCollectionCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import <UIKit/UIKit.h>
#import "MDYFreeCourseRequest.h"
#import "MDYHomeExclusiveCourseRequest.h"
#import "MDYMallHomeReqeust.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYCurriculumCollectionCell : UICollectionViewCell
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *notes;

@property (nonatomic, strong) MDYFreeCourseModel *freeModel;
@property (nonatomic, strong) MDYHomeExclusiveCourseModel *exclusiveModel;
@property (nonatomic, strong) MDYMallHomeModel *mallModel;
@end

NS_ASSUME_NONNULL_END
