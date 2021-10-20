//
//  MDYCourseDetailTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/24.
//

#import "MDYCourseDetailTableCell.h"
#import "MDYWKWebView.h"
@interface MDYCourseDetailTableCell ()<WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet MDYWKWebView *wkWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;

//@property (nonatomic, assign)
@end

@implementation MDYCourseDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.wkWebView.navigationDelegate = self;
}
- (void)setDetailModel:(MDYCourseDetailModel *)detailModel {
    _detailModel = detailModel;
    if (detailModel) {
        NSString *htmls = [detailModel.info changeHtmlString];
        [self.wkWebView loadHTMLString:htmls baseURL:[NSURL URLWithString:@""]];
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
- (void)layoutSubviews {
    [super layoutSubviews];
//    self.wkWebView.frame = self.bounds;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
