//
//  MDYAboutUsController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/21.
//

#import "MDYAboutUsController.h"

@interface MDYAboutUsController ()

@end

@implementation MDYAboutUsController
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
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"关于我们";
}

@end
