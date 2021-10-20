//
//  MDYOrderPayTypeTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYOrderPayTypeTableCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign,getter=isSelect) BOOL select;
@end

NS_ASSUME_NONNULL_END
