//
//  MDYCourseTImeKillTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/24.
//

#import "MDYCourseTImeKillTableCell.h"

@interface MDYCourseTImeKillTableCell ()
@property (weak, nonatomic) IBOutlet UIView *hourView;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UIView *miuteView;
@property (weak, nonatomic) IBOutlet UILabel *miuteLabel;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@end

@implementation MDYCourseTImeKillTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.hourView.layer setCornerRadius:4];
    [self.miuteView.layer setCornerRadius:4];
    [self.secondView.layer setCornerRadius:4];
}
- (void)timerAction {
    if (self.countDownTime <= 0) {
        [MBProgressHUD showMessage:@"当前活动已结束"];
        [[UIViewController currentNavigatonController] popViewControllerAnimated:YES];
        return;
    }
    NSTimeInterval time = self.countDownTime;
    NSDate *myDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *firstDate = [NSDate date];
    NSString *firstDateStr = [formatter stringFromDate:firstDate];
    NSString *afterDateStr = [formatter stringFromDate:myDate];
    NSDate *afterDate = [formatter dateFromString:afterDateStr];
    
    // 当前时间data格式
    firstDate = [formatter dateFromString:firstDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth| NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差        先是 早的时间      后是 晚的时间
    NSDateComponents *dateCom = [calendar components:unit fromDate:firstDate toDate:afterDate options:0];
    [self.hourLabel setText:[NSString stringWithFormat:@"%02ld",dateCom.day * 24 + dateCom.hour]];
    [self.miuteLabel setText:[NSString stringWithFormat:@"%02ld",dateCom.minute]];
    [self.secondLabel setText:[NSString stringWithFormat:@"%02ld",dateCom.second]];
}
- (void)setCountDownTime:(NSInteger)countDownTime {
    _countDownTime = countDownTime;
    if (countDownTime > 0) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
