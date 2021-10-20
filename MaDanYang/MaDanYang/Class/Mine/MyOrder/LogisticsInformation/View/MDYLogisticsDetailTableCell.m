//
//  MDYLogisticsDetailTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/17.
//

#import "MDYLogisticsDetailTableCell.h"

@interface MDYLogisticsDetailTableCell ()
@property (weak, nonatomic) IBOutlet UIView *botView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@end

@implementation MDYLogisticsDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.botView.layer setCornerRadius:6];
}
- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setText:title];
    self.headImageView.hidden = NO;
    self.line.hidden = NO;
    if ([title isEqualToString:@"已下单"]) {
        self.line.hidden = YES;
        [self.headImageView setImage:[UIImage imageNamed:@"order_place_icon"]];
    } else if ([title isEqualToString:@"已发货"]) {
        [self.headImageView setImage:[UIImage imageNamed:@"order_deliver_icon"]];
    } else if ([title isEqualToString:@"运输中"]) {
        [self.headImageView setImage:[UIImage imageNamed:@"order_transport_icon"]];
    } else if ([title isEqualToString:@"派送中"]) {
        [self.headImageView setImage:[UIImage imageNamed:@"order_delivery_icon"]];
    } else if ([title isEqualToString:@"已收货"]) {
        [self.headImageView setImage:[UIImage imageNamed:@"order_harvest_icon"]];
    } else {
        self.headImageView.hidden = YES;
    }
}
- (void)setRouteModel:(MDYOrderSynquerysRouteModel *)routeModel {
    _routeModel = routeModel;
    if (routeModel) {
        [self.titleLabel setText:routeModel.status];
        [self.timeLabel setText:routeModel.time];
        [self.detailLabel setText:routeModel.context];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
