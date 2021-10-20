//
//  MDYSearchHistoryCollectionCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYSearchHistoryCollectionCell : UICollectionViewCell
@property (nonatomic, copy) NSString *title;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

NS_ASSUME_NONNULL_END
