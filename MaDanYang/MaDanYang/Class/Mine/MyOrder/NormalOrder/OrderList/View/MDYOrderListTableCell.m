//
//  MDYOrderListTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/16.
//

#import "MDYOrderListTableCell.h"

@interface MDYOrderListTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *enterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;

@end

@implementation MDYOrderListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bigImageView.layer setCornerRadius:6];
    
    [self.changeButton.layer setCornerRadius:4];
    [self.cancelButton.layer setCornerRadius:4];
    [self.enterLabel.layer setCornerRadius:4];
    
    [self.enterLabel.layer setBorderWidth:1];
    [self.cancelButton.layer setBorderWidth:1];
    [self.changeButton.layer setBorderWidth:1];
    
    [self.changeButton setClipsToBounds:YES];
    [self.cancelButton setClipsToBounds:YES];
    [self.enterLabel setClipsToBounds:YES];
    
    self.flagImageView.hidden = YES;
    self.flagLabel.hidden = YES;
}
- (void)setOrderTyp:(MDYOrderType)orderTyp {
    _orderTyp = orderTyp;
    if (orderTyp == MDYOrderTypeOfToPaid) {
        [self.typeLabel setText:@"待付款"];
        [self.typeLabel setTextColor:KHexColor(0x2D82E5FF)];
        self.changeButton.hidden = YES;
        self.cancelButton.hidden = NO;
        self.enterLabel.hidden = NO;
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton.layer setBorderColor:K_SeparatorColor.CGColor];
        
        [self.enterLabel setTitleColor:K_WhiteColor forState:UIControlStateNormal];
        [self.enterLabel setTitle:@"付款" forState:UIControlStateNormal];
        [self.enterLabel.layer setBorderColor:K_MainColor.CGColor];
        [self.enterLabel setBackgroundColor:K_MainColor];
    } else if (orderTyp == MDYOrderTypeOfToDelivered) {
        [self.typeLabel setText:@"待发货"];
        [self.typeLabel setTextColor:KHexColor(0x2D82E5FF)];
        self.changeButton.hidden = YES;
        self.cancelButton.hidden = YES;
        self.enterLabel.hidden = NO;
        [self.enterLabel setTitle:@"提醒发货" forState:UIControlStateNormal];
        [self.enterLabel setTitleColor:K_TextLightGrayColor forState:UIControlStateNormal];
        [self.enterLabel.layer setBorderColor:K_SeparatorColor.CGColor];
        [self.enterLabel setBackgroundColor:K_WhiteColor];
        if ([self.orderModel.type integerValue] == 2) {
            [self.typeLabel setText:@"审核中"];
            self.enterLabel.hidden = YES;
        }
    } else if (orderTyp == MDYOrderTypeOfToReceived) {
        [self.typeLabel setText:@"待收货"];
        [self.typeLabel setTextColor:K_MainColor];
        if (self.orderModel.order_type == 1) {
            self.changeButton.hidden = NO;
        } else {
            self.changeButton.hidden = YES;
        }
        self.cancelButton.hidden = NO;
        self.enterLabel.hidden = NO;
        [self.cancelButton setTitle:@"查看物流" forState:UIControlStateNormal];
        [self.cancelButton.layer setBorderColor:K_SeparatorColor.CGColor];
        
        
        [self.changeButton setTitle:@"申请换货" forState:UIControlStateNormal];
        [self.changeButton.layer setBorderColor:K_SeparatorColor.CGColor];
        
        [self.enterLabel setTitleColor:K_WhiteColor forState:UIControlStateNormal];
        [self.enterLabel setTitle:@"确认收货" forState:UIControlStateNormal];
        [self.enterLabel.layer setBorderColor:K_MainColor.CGColor];
        [self.enterLabel setBackgroundColor:K_MainColor];
    } else if (orderTyp == MDYOrderTypeOfUnderReview) {
        [self.typeLabel setText:@"审核中"];
        [self.typeLabel setTextColor:KHexColor(0xF37575FF)];
        self.changeButton.hidden = YES;
        self.cancelButton.hidden = YES;
        self.enterLabel.hidden = YES;
    } else if (orderTyp == MDYOrderTypeOfToFilledIn) {
        [self.typeLabel setText:@"待填写"];
        [self.typeLabel setTextColor:KHexColor(0xF37575FF)];
        self.changeButton.hidden = YES;
        self.cancelButton.hidden = YES;
        self.enterLabel.hidden = NO;
        
        [self.enterLabel setTitleColor:K_WhiteColor forState:UIControlStateNormal];
        [self.enterLabel setTitle:@"填写单号" forState:UIControlStateNormal];
        [self.enterLabel.layer setBorderColor:K_MainColor.CGColor];
        [self.enterLabel setBackgroundColor:K_MainColor];
    } else if (orderTyp == MDYOrderTypeOfRefuse) {
        [self.typeLabel setText:@"已拒绝"];
        [self.typeLabel setTextColor:K_TextLightGrayColor];
        self.changeButton.hidden = YES;
        self.cancelButton.hidden = YES;
        self.enterLabel.hidden = YES;
        
        [self.enterLabel setTitleColor:K_WhiteColor forState:UIControlStateNormal];
        [self.enterLabel setTitle:@"填写单号" forState:UIControlStateNormal];
        [self.enterLabel.layer setBorderColor:K_MainColor.CGColor];
        [self.enterLabel setBackgroundColor:K_MainColor];
    } else {
        [self.typeLabel setText:@"已完成"];
        [self.typeLabel setTextColor:K_TextLightGrayColor];
        self.changeButton.hidden = YES;
        self.cancelButton.hidden = YES;
        self.enterLabel.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)enterButtonAction:(UIButton *)sender {
    if (self.didClickButton) {
        self.didClickButton(2,self.orderTyp);
    }
}
- (IBAction)cancelButtonAction:(UIButton *)sender {
    if (self.didClickButton) {
        self.didClickButton(1,self.orderTyp);
    }
}
- (IBAction)changeButtonAction:(UIButton *)sender {
    if (self.didClickButton) {
        self.didClickButton(0,self.orderTyp);
    }
}
- (void)setOrderModel:(MDYMyOrderListModel *)orderModel {
    _orderModel = orderModel;
    if (orderModel) {
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:orderModel.order_img]];
        [self.titleLabel setText:orderModel.order_name];
        [self.moneyLabel setText:[NSString stringWithFormat:@"¥ %@",orderModel.pay_price]];
        [self.numLabel setText:[NSString stringWithFormat:@"X %@",orderModel.num]];
        if (self.isGroupOrder) {
            [self.typeLabel setText:@"拼团中"];
            [self.typeLabel setTextColor:KHexColor(0x2D82E5FF)];
            self.changeButton.hidden = YES;
            self.cancelButton.hidden = YES;
            self.enterLabel.hidden = YES;
            return;
        }
        if ([orderModel.state integerValue] == 0) {
            self.orderTyp = MDYOrderTypeOfToPaid;
        } else if ([orderModel.state integerValue] == 1) {
            self.orderTyp = MDYOrderTypeOfToDelivered;
        } else if ([orderModel.state integerValue] == 2) {
            self.orderTyp = MDYOrderTypeOfToReceived;
        } else if ([orderModel.state integerValue] == 3) {
            self.orderTyp = MDYOrderTypeOfUnderReview;
        } else if ([orderModel.state integerValue] == 4) {
            self.orderTyp = MDYOrderTypeOfToFilledIn;
        } else if ([orderModel.state integerValue] == 5) {
            self.orderTyp = MDYOrderTypeOfRefuse;
        } else if ([orderModel.state integerValue] == 10) {
            self.orderTyp = MDYOrderTypeOfCompleted;
        } else {
            self.changeButton.hidden = YES;
            self.cancelButton.hidden = YES;
            self.enterLabel.hidden = YES;
            [self.typeLabel setText:@"已取消"];
            [self.typeLabel setTextColor:K_TextLightGrayColor];
        }
        if (orderModel.order_type == 2) {
            self.flagImageView.hidden = NO;
            self.flagLabel.hidden = NO;
            [self.flagImageView setImage:[[UIImage imageNamed:@"search_flag_group"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20) resizingMode:UIImageResizingModeStretch]];
            [self.flagLabel setText:@"拼团"];
        } else if (orderModel.order_type == 3) {
            self.flagImageView.hidden = NO;
            self.flagLabel.hidden = NO;
            [self.flagImageView setImage:[[UIImage imageNamed:@"search_flag_time"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20) resizingMode:UIImageResizingModeStretch]];
            [self.flagLabel setText:@"秒杀"];
        } else {
            self.flagImageView.hidden = YES;
            self.flagLabel.hidden = YES;
        }
    }
}
- (void)setIntegralModel:(MDYIntegralOrderListModel *)integralModel {
    _integralModel = integralModel;
    if (integralModel) {
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:integralModel.order_img]];
        [self.titleLabel setText:integralModel.order_name];
        [self.moneyLabel setText:[NSString stringWithFormat:@"%@积分",integralModel.pay_price]];
        [self.numLabel setText:[NSString stringWithFormat:@"X %@",integralModel.num]];
        if ([integralModel.state integerValue] == 0) {
            self.orderTyp = MDYOrderTypeOfToPaid;
            self.changeButton.hidden = YES;
            self.cancelButton.hidden = YES;
            self.enterLabel.hidden = YES;
        } else if ([integralModel.state integerValue] == 1) {
            self.orderTyp = MDYOrderTypeOfToDelivered;
            self.changeButton.hidden = YES;
            self.cancelButton.hidden = YES;
            self.enterLabel.hidden = YES;
        } else if ([integralModel.state integerValue] == 2) {
            self.orderTyp = MDYOrderTypeOfToReceived;
            self.changeButton.hidden = YES;
            self.cancelButton.hidden = NO;
            self.enterLabel.hidden = NO;
            [self.cancelButton setTitle:@"查看物流" forState:UIControlStateNormal];
            [self.cancelButton.layer setBorderColor:K_SeparatorColor.CGColor];
            
            [self.enterLabel setTitleColor:K_WhiteColor forState:UIControlStateNormal];
            [self.enterLabel setTitle:@"确认收货" forState:UIControlStateNormal];
            [self.enterLabel.layer setBorderColor:K_MainColor.CGColor];
            [self.enterLabel setBackgroundColor:K_MainColor];
        } else if ([integralModel.state integerValue] == 3) {
            self.orderTyp = MDYOrderTypeOfUnderReview;
            self.changeButton.hidden = YES;
            self.cancelButton.hidden = YES;
            self.enterLabel.hidden = YES;
        } else if ([integralModel.state integerValue] == 4) {
            self.orderTyp = MDYOrderTypeOfToFilledIn;
            self.changeButton.hidden = YES;
            self.cancelButton.hidden = YES;
            self.enterLabel.hidden = YES;
        } else if ([integralModel.state integerValue] == 5) {
            self.orderTyp = MDYOrderTypeOfRefuse;
            self.changeButton.hidden = YES;
            self.cancelButton.hidden = YES;
            self.enterLabel.hidden = YES;
        } else if ([integralModel.state integerValue] == 10) {
            self.orderTyp = MDYOrderTypeOfCompleted;
            self.changeButton.hidden = YES;
            self.cancelButton.hidden = YES;
            self.enterLabel.hidden = YES;
        }
    }
}
@end
