//
//  MDYAppointmentListTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/19.
//

#import <UIKit/UIKit.h>
#import "MDYMyGuidanceListRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYAppointmentListTableCell : UITableViewCell
@property (nonatomic, assign) NSInteger type; // 0 = 待审核 1 = 待上门 2 = 完成
@property (nonatomic, copy) void(^didClickPulic)(void);
@property (nonatomic, strong) MDYMyGuidanceListModel *guidanceModel;
@end

NS_ASSUME_NONNULL_END
