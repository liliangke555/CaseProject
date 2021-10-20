//
//  MDYWKWebView.m
//  MaDanYang
//
//  Created by kckj on 2021/8/9.
//

#import "MDYWKWebView.h"

@implementation MDYWKWebView

- (instancetype)initWithCoder:(NSCoder *)coder {
    CGRect frame = [[UIScreen mainScreen] bounds];
    WKWebViewConfiguration *myConfiguration = [WKWebViewConfiguration new];
    self = [super initWithFrame:frame configuration:myConfiguration];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return self;
}

@end
