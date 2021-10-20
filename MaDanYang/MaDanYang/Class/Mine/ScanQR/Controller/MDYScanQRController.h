//
//  MDYScanQRController.h
//  MaDanYang
//
//  Created by kckj on 2021/6/21.
//

#import "CKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MDYScanQRCodeDelegate <NSObject>

- (void)scanQRCodeFinish:(NSString *)valueString;

@end
@interface MDYScanQRController : CKBaseViewController
@property (nonatomic, weak) id <MDYScanQRCodeDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
