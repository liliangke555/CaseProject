//
//  MMSheetView.m
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMSheetView.h"
#import "MMPopupItem.h"
#import "MMPopupCategory.h"
#import "MMPopupDefine.h"
#import <Masonry/Masonry.h>

@interface MMSheetView()

@property (nonatomic, strong) UIView      *titleView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIView      *buttonView;
@property (nonatomic, strong) UIButton    *cancelButton;

@property (nonatomic, strong) NSArray     *actionItems;

@end

@implementation MMSheetView

- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items {
    self = [super init];
    if ( self ) {
        NSAssert(items.count>0, @"Could not find any items.");
        
        MMSheetViewConfig *config = [MMSheetViewConfig globalConfig];
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        self.type = MMPopupTypeSheet;
        self.actionItems = items;
        
//        self.backgroundColor = config.backgroundColor;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        if ( title.length > 0 )
        {
            self.titleView = [UIView new];
            [self addSubview:self.titleView];
            [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
            }];
            self.titleView.backgroundColor = config.backgroundColor;
            
            self.titleLabel = [UILabel new];
            [self.titleView addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.titleView).insets(UIEdgeInsetsMake(config.innerMargin, config.innerMargin, config.innerMargin, config.innerMargin));
            }];
            self.titleLabel.textColor = MMHexColor(0x333333FF);
            self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.text = title;
            
            lastAttribute = self.titleView.mas_bottom;
        }
        
        self.buttonView = [UIView new];
        [self addSubview:self.buttonView];
        [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 8, 0, 8));
            make.top.equalTo(lastAttribute);
        }];
        [self.buttonView.layer setCornerRadius:6];
        [self.buttonView setClipsToBounds:YES];
        lastAttribute = self.buttonView.mas_bottom;
        
        __block UIButton *firstButton = nil;
        __block UIButton *lastButton = nil;
        for ( NSInteger i = 0 ; i < items.count; ++i ) {
            MMPopupItem *item = items[i];
            
            UIButton *btn = [UIButton mm_buttonWithTarget:self action:@selector(actionButton:)];
            [self.buttonView addSubview:btn];
            btn.tag = i;
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.right.equalTo(self.buttonView).insets(UIEdgeInsetsMake(0, -MM_SPLIT_WIDTH, 0, -MM_SPLIT_WIDTH));
                make.height.mas_equalTo(config.buttonHeight);
                
                if ( !firstButton ) {
                    firstButton = btn;
                    make.top.equalTo(self.buttonView.mas_top).offset(-MM_SPLIT_WIDTH);
                } else {
                    make.top.equalTo(lastButton.mas_bottom).offset(-MM_SPLIT_WIDTH);
                    make.height.equalTo(firstButton);
                }
                
                lastButton = btn;
            }];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateDisabled];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn setTitleColor:item.highlight?config.itemHighlightColor:item.disabled?config.itemDisableColor:config.itemNormalColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = config.splitColor.CGColor;
            btn.enabled = !item.disabled;
            
        }
        
        UIButton *cancelButton = [UIButton mm_buttonWithTarget:self action:@selector(actionCancel)];
        [self addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(8);
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 8, 0, 8));
            make.height.mas_equalTo(44);
        }];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateDisabled];
        [cancelButton setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
        [cancelButton setTitleColor:MMHexColor(0x999999FF) forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [cancelButton.layer setCornerRadius:6];
        [cancelButton setClipsToBounds:YES];
        lastAttribute = cancelButton.mas_bottom;
        
        [lastButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.buttonView.mas_bottom).offset(MM_SPLIT_WIDTH);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastAttribute).offset(KBottomSafeHeight);
        }];
    }
    return self;
}

- (void)actionButton:(UIButton*)btn
{
    MMPopupItem *item = self.actionItems[btn.tag];
    
    [self hide];
    
    if ( item.handler )
    {
        item.handler(btn.tag);
    }
}

- (void)actionCancel
{
    [self hide];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self clipCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10.0f];
}

@end


@interface MMSheetViewConfig()

@end

@implementation MMSheetViewConfig

+ (MMSheetViewConfig *)globalConfig
{
    static MMSheetViewConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config = [MMSheetViewConfig new];
        
    });
    
    return config;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.buttonHeight   = 50.0f;
        self.innerMargin    = 19.0f;
        
        self.titleFontSize  = 18.0f;
        self.buttonFontSize = 17.0f;
        
        self.backgroundColor    = MMHexColor(0xFFFFFFFF);
        self.titleColor         = MMHexColor(0x000000FF);
        self.splitColor         = MMHexColor(0xE6EAE9FF);
        
        self.itemNormalColor    = MMHexColor(0x2D82E5FF);
        self.itemDisableColor   = MMHexColor(0xCCCCCCFF);
        self.itemHighlightColor = MMHexColor(0x2CCBF4FF);
        self.itemPressedColor   = MMHexColor(0xEFEDE7FF);
        
        self.defaultTextCancel  = @"close";
    }
    
    return self;
}

@end
