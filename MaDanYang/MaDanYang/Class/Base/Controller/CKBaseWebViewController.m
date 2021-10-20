//
//  CKBaseWebViewController.m
//  CloudKind
//
//  Created by kckj on 2021/5/14.
//

#import "CKBaseWebViewController.h"

@interface CKBaseWebViewController (){
    WKWebViewConfiguration *_config;
    UILabel *_labelTitle;
    NSDictionary *_dataToShare;
    NSString *_stringTitle;
}

@end

@implementation CKBaseWebViewController

- (instancetype)initWithTitle:(NSString *)stringTitle {
    if (self == [super init]) {
        _stringTitle = stringTitle;
    }
    return self;
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"title"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    NSDictionary *textAttributes = @{
        NSFontAttributeName : KMediumFont(17),
        NSForegroundColorAttributeName : K_TextBlackColor,
    };
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _stringTitle;
    
    //创建网页配置对象
    [self ___setConfiguration];
    _webView = [[WKWebView alloc] init];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    _webView.allowsBackForwardNavigationGestures = NO;
    if (_stringUrl.length > 0) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_stringUrl]]];
    }
    if (_htmlString.length > 0) {
        NSString *htmls = [_htmlString changeHtmlString];
        [_webView loadHTMLString:htmls baseURL:[NSURL URLWithString:_stringUrl]];
    }
    
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)pressNavLeftButton
:(UIButton *)button {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]) {
        if (object == _webView) {
            if (_webView.title.length > 0) {
                _labelTitle.text = _webView.title;
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//创建网页配置对象
- (void)___setConfiguration {
    _config = [[WKWebViewConfiguration alloc] init];
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc] init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    _config.preferences = preference;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler {
    //如果是跳转一个新页面
    if(navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


@end
