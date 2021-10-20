//
//  MDYLogisticsDetailTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/17.
//

#import <UIKit/UIKit.h>
#import "MDYOrderSynquerysRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYLogisticsDetailTableCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (nonatomic, strong) MDYOrderSynquerysRouteModel *routeModel;
@end

NS_ASSUME_NONNULL_END
