//
//  MDYItmeCollectionCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol  MDYItemCollectionCellDelegate <NSObject>

- (void)didSelectedIndex:(NSString *)title;

@end
static NSString *titleKey = @"titleKey";
static NSString *imageKey = @"imageKey";
@interface MDYItmeCollectionCell : UICollectionViewCell
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) id <MDYItemCollectionCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
