//
//  MDYChangePhotoTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYChangePhotoTableCell : UITableViewCell
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger maxPhoto;
@property (nonatomic, copy) void(^didClickAdd)(void);
@property (nonatomic, copy) void(^didClickReview)(NSInteger index);
@property (nonatomic, copy) void(^didClickDelete)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
