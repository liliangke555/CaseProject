//
//  MDYDynamicDetailTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/9.
//

#import <UIKit/UIKit.h>
#import "MDYHomeDynamicRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYDynamicDetailTableCell : UITableViewCell
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) void(^didReviewImage)(NSArray *imageData,NSInteger index);
@property (nonatomic, strong) MDYHomeDynamicModel *dynamicModel;
@end

NS_ASSUME_NONNULL_END
