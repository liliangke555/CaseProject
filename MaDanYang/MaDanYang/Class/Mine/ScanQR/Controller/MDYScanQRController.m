//
//  MDYScanQRController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/21.
//

#import "MDYScanQRController.h"
#import <AVFoundation/AVFoundation.h>
@interface MDYScanQRController ()<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;

@end
static CGFloat const ScanWidth = 215.0f;
@implementation MDYScanQRController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage ck_imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:KHexColor(0xFFFFFFFF)}];
    
}
- (void)pressNavLeftButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"扫描二维码";
    [self initView];
}

- (void)initView {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton setImage:[UIImage imageNamed:@"navigation_white"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigation_white"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"  返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:KSystemFont(16)];
    [backButton setTitleColor:K_WhiteColor forState:UIControlStateNormal];
    [backButton setTitleColor:K_TextLightGrayColor forState:UIControlStateHighlighted];
    // 调整图片的位置
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    // 添加事件
    [backButton addTarget:self action:@selector(pressNavLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    if (self.device == nil) {
        __weak typeof(self)weakSelf = self;
        MMPopupItemHandler block = ^(NSInteger index){
                NSLog(@"clickd %@ button",@(index));
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        NSArray *items =@[MMItemMake(@"我知道了", MMItemTypeNormal, block)];
        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                             detail:@"未检测到摄像头！"
                                                              items:items];
        [alertView show];
        return;
    }
    
    // 在扫描之前加了判断相机的访问权限：
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        __weak typeof(self)weakSelf = self;
        MMPopupItemHandler block = ^(NSInteger index){
                NSLog(@"clickd %@ button",@(index));
            if (index == 0) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        };
        NSArray *items =@[MMItemMake(@"我知道了", MMItemTypeNormal, block),
                          MMItemMake(@"设置", MMItemTypeHighlight, block)];
        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                             detail:@"请在iPhone的“设置”-“隐私”-“相机”功能中，找到“马丹阳”打开相机访问权限"
                                                              items:items];
        [alertView show];
        return;
    }
    [self addImageView];
    [self scanSetup];
}
//添加扫描框
- (void)addImageView {
    
    UIImageView *scanImageView = [[UIImageView alloc] init];
    [self.view addSubview:scanImageView];
    [scanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).mas_offset(100 + KNavBarAndStatusBarHeight);
    }];
    [scanImageView setImage:[UIImage imageNamed:@"mine_scan_qrcode"]];
    
    UIView *topView = [[UIView alloc] init];
    [self.view insertSubview:topView belowSubview:scanImageView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
        make.bottom.equalTo(scanImageView.mas_top).mas_offset(4);
    }];
    [topView setBackgroundColor:KHexColor(0x00000099)];
    
    UIView *leftView = [[UIView alloc] init];
    [self.view insertSubview:leftView belowSubview:scanImageView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(scanImageView.mas_bottom).mas_offset(-4);
        make.top.equalTo(topView.mas_bottom);
        make.right.equalTo(scanImageView.mas_left).mas_offset(4);
    }];
    [leftView setBackgroundColor:KHexColor(0x00000099)];
    
    UIView *rightView = [[UIView alloc] init];
    [self.view insertSubview:rightView belowSubview:scanImageView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(scanImageView.mas_bottom).mas_offset(-4);
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(scanImageView.mas_right).mas_offset(-4);
    }];
    [rightView setBackgroundColor:KHexColor(0x00000099)];
    
    UIView *bottomView = [[UIView alloc] init];
    [self.view insertSubview:bottomView belowSubview:scanImageView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
        make.top.equalTo(scanImageView.mas_bottom).mas_offset(-4);
    }];
    [bottomView setBackgroundColor:KHexColor(0x00000099)];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(scanImageView.mas_bottom).mas_offset(32);
    }];
    [titleLabel setText:@"将二维码放入框内，即可自动扫描"];
    [titleLabel setFont:KMediumFont(14)];
    [titleLabel setTextColor:K_WhiteColor];
    
    UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(openAlbumAction)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(-32 - KBottomSafeHeight);
    }];
    [button setImage:[UIImage imageNamed:@"f_album_icon"] forState:UIControlStateNormal];
    
//    UIImageView *imageView = [[UIImageView alloc] init];
//    [self.view addSubview:imageView];
//    [imageView setImage:[UIImage imageNamed:@"qr_point"]];
//    self.pointImage = imageView;
}
//初始化扫描配置
- (void)scanSetup {
    self.preview.videoGravity = AVLayerVideoGravityResize;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode]];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    [self.session startRunning];
}
#pragma mark - IBAction
- (void)openAlbumAction {
    [self choicePhoto];
}
- (void)choicePhoto{
  //调用相册
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
  imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  imagePicker.delegate = self;
  [self presentViewController:imagePicker animated:YES completion:nil];
}
//选中图片的回调
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  NSString *content = @"" ;
  //取出选中的图片
  UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
  NSData *imageData = UIImagePNGRepresentation(pickImage);
  CIImage *ciImage = [CIImage imageWithData:imageData];
  //创建探测器
  CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
  NSArray *feature = [detector featuresInImage:ciImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
  //取出探测到的数据
  for (CIQRCodeFeature *result in feature) {
      content = result.messageString;
  }
    if (content.length > 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([self.delegate respondsToSelector:@selector(scanQRCodeFinish:)]) {
            [self.delegate scanQRCodeFinish:content];
        }
    } else {
        [MBProgressHUD showMessage:@"未识别到二维码"];
    }
  //进行处理(音效、网址分析、页面跳转等)
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        if ([metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            NSString *stringValue = [metadataObject stringValue];
            [self pointScanQRWithPoits:[metadataObject corners]];
            if (stringValue != nil) {
                [self.session stopRunning];
                NSLog(@"%@",stringValue);
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self.delegate respondsToSelector:@selector(scanQRCodeFinish:)]) {
                        [self.delegate scanQRCodeFinish:stringValue];
                    }
                }];
            }
        }
    }
}
/// 计算二维码中心点
/// @param array 二维码四个点的坐标
- (void)pointScanQRWithPoits:(NSArray *)array {
    if ([array count] < 3) {
        return;
    }
    NSDictionary *oneDic = array[0];
    NSDictionary *twoDic = array[2];
    CGFloat oneY = [[oneDic objectForKey:@"Y"] floatValue];
    CGFloat oneX = [[oneDic objectForKey:@"X"] floatValue];
    CGFloat twoY = [[twoDic objectForKey:@"Y"] floatValue];
    CGFloat twoX = [[twoDic objectForKey:@"X"] floatValue];
    CGFloat centerX = (1 - ((fabs(oneY - twoY) / 2.0) + (oneY > twoY ? twoY : oneY))) * CGRectGetWidth(self.preview.frame);
    CGFloat centerY = ((fabs(oneX - twoX) / 2.0) + (oneX > twoX ? twoX : oneX)) * CGRectGetHeight(self.preview.frame);
    
//    self.pointImage.frame = CGRectMake(0, 0, 28, 28);
//    self.pointImage.center = CGPointMake(centerX, centerY);
}
#pragma mark - Getter
- (AVCaptureDevice *)device {
    if (_device == nil) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}
 
- (AVCaptureDeviceInput *)input {
    if (_input == nil) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}
 
- (AVCaptureMetadataOutput *)output {
    
    if (_output == nil) {
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //限制扫描区域(上下左右)
        CGFloat y = (100 + KNavBarAndStatusBarHeight) / CK_HEIGHT;
        CGFloat x = ((CK_WIDTH - ScanWidth) / 2.0f) / CK_WIDTH;
        [_output setRectOfInterest:CGRectMake(y, x, ScanWidth / CK_HEIGHT, ScanWidth / CK_WIDTH)];
    }
    return _output;
}
 
- (AVCaptureSession *)session {
    if (_session == nil) {
        //session
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        if ([_session canAddOutput:self.output]) {
            [_session addOutput:self.output];
        }
    }
    return _session;
}
 
- (AVCaptureVideoPreviewLayer *)preview {
    if (_preview == nil) {
        _preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    return _preview;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.preview.frame = CGRectMake(0, 0, CK_WIDTH, CGRectGetHeight(self.view.frame));
}
@end
