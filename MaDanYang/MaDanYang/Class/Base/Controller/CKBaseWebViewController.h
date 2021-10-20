//
//  CKBaseWebViewController.h
//  CloudKind
//
//  Created by kckj on 2021/5/14.
//

#import "CKBaseViewController.h"
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CKBaseWebViewController : CKBaseViewController<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *stringUrl;
@property (nonatomic, strong) NSString *htmlString;

- (instancetype)initWithTitle:(NSString *)stringTitle;

@end

NS_ASSUME_NONNULL_END
