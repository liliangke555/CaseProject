//
//  MDYMyCourseTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/19.
//

#import "MDYMyCourseTableCell.h"

@interface MDYMyCourseTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *flagLbabel;
@property (weak, nonatomic) IBOutlet UIView *flagView;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@end

@implementation MDYMyCourseTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headImageView.layer setCornerRadius:6];
    [self.flagView.layer setCornerRadius:2];
    [self.flagView setClipsToBounds:YES];
}
- (void)setCourseModel:(MDYMyCourseListModel *)courseModel {
    _courseModel = courseModel;
    if (courseModel) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:courseModel.curriculum_img]];
        [self.titleLabel setText:courseModel.curriculum_name];
        [self.flagLbabel setText:courseModel.curriculum_type[0]];
        [self.noteLabel setText:courseModel.progress_bar];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
