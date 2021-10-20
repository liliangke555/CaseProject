//
//  MDYMyAddressTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/21.
//

#import <UIKit/UIKit.h>
#import "MDYMyAddressListRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYMyAddressTableCell : UITableViewCell
@property (nonatomic, copy) void(^didClickEdit)(void);
@property (nonatomic, copy) void(^didClickDelete)(void);
@property (nonatomic, copy) void(^didClickSelected)(void);
@property (nonatomic, assign, getter=isNormal) BOOL normal;
@property (nonatomic, strong) MDYMyAddressListModel *addressModel;
@end

NS_ASSUME_NONNULL_END
