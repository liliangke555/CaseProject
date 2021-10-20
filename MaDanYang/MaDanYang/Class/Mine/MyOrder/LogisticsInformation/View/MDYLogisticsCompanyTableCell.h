//
//  MDYLogisticsCompanyTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/17.
//

#import <UIKit/UIKit.h>
#import "MDYOrderSynquerysRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYLogisticsCompanyTableCell : UITableViewCell
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) MDYOrderSynquerysModel *infoModel;
@end

NS_ASSUME_NONNULL_END
