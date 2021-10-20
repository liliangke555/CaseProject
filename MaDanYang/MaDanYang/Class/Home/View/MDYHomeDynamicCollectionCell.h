//
//  MDYHomeDynamicCollectionCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYHomeDynamicCollectionCell : UICollectionViewCell
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *headerImage;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, assign) NSInteger integralNum;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, copy) void(^didClickCheck)(void);
@property (nonatomic, assign, getter=isExhibition) BOOL exhibition;
@property (nonatomic, copy) void(^didCheckImage)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
