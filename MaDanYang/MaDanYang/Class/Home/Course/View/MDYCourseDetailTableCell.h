//
//  MDYCourseDetailTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/24.
//

#import <UIKit/UIKit.h>
#import "MDYCourseDetailRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYCourseDetailTableCell : UITableViewCell
@property (nonatomic, strong) MDYCourseDetailModel *detailModel;
@property (nonatomic, copy) void(^didReloadView)(void);
@end

NS_ASSUME_NONNULL_END
