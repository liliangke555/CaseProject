//
//  MDYLeavMessageCollectionCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYLeavMessageCollectionCell : UICollectionViewCell
@property (nonatomic, copy) void(^didClickRecord)(UIView *view);
@property (nonatomic, copy) void(^didEditName)(NSString *string);
@property (nonatomic, copy) void(^didEditPhone)(NSString *string);
@property (nonatomic, copy) void(^didEditDetail)(NSString *string);
@end

NS_ASSUME_NONNULL_END
