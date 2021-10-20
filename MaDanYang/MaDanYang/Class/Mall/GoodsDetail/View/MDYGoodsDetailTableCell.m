//
//  MDYGoodsDetailTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/8/9.
//

#import "MDYGoodsDetailTableCell.h"
#import "MDYWKWebView.h"
@interface MDYGoodsDetailTableCell ()<WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;
@property (weak, nonatomic) IBOutlet MDYWKWebView *wkWebView;

@end

@implementation MDYGoodsDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.wkWebView.navigationDelegate = self;
}
- (void)setHtmlString:(NSString *)htmlString {
    _htmlString = htmlString;
    if (htmlString.length > 0) {
        NSString *htmls = [htmlString changeHtmlString];
        [self.wkWebView loadHTMLString:htmls baseURL:nil];
    }
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    CKWeakify(self);
    [webView evaluateJavaScript:@"document.body.scrollWidth"completionHandler:^(id _Nullable result,NSError * _Nullable error){
            
            CGFloat ratio =  CGRectGetWidth(self.wkWebView.frame) /[result floatValue];
            NSLog(@"scrollWidth高度：%.2f",[result floatValue]);
            
            [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
                
                NSLog(@"scrollHeight高度：%.2f",[result floatValue]*ratio);
                if (weakSelf.webViewHeight.constant < [result floatValue]*ratio) {
                    weakSelf.webViewHeight.constant = [result floatValue]*ratio;
                    if (weakSelf.didReloadView) {
                        weakSelf.didReloadView();
                    }
                }
            }];
            
        }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
