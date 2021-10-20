//
//  MDYCourseTitleTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/23.
//

#import <UIKit/UIKit.h>
#import "MDYCourseDetailRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYCourseTitleTableCell : UITableViewCell
@property (nonatomic, strong) NSArray *flagArray;
@property (nonatomic, strong) MDYCourseDetailModel *detailModel;
@end

NS_ASSUME_NONNULL_END
