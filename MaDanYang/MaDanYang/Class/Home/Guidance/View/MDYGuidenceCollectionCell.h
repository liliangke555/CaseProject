//
//  MDYGuidenceCollectionCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/9.
//

#import <UIKit/UIKit.h>
#import "MDYGuidanceListRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MDYGuidenceCollectionCell : UICollectionViewCell
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) MDYGuidanceListModel *guidaceModel;
@end

NS_ASSUME_NONNULL_END
