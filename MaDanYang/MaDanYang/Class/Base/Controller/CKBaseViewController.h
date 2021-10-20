//
//  CKBaseViewController.h
//  CloudKind
//
//  Created by kckj on 2021/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CKBaseViewController : UIViewController
@property (nonatomic, assign) NSInteger maxPhoto;
@property (nonatomic, strong) NSMutableArray *photoSource;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
- (void)animation;
- (void)addImage;
- (void)reviewImage:(NSInteger)index;
-(void)refreshView;
- (void)showBrowerWithIndex:(NSInteger)index data:(NSArray *)data view:(id __nullable)view;
- (void)createLeftButtonWithaboveSubview:(id)view;
@end

NS_ASSUME_NONNULL_END
