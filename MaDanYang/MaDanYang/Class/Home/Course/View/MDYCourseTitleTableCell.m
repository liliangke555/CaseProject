//
//  MDYCourseTitleTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/23.
//

#import "MDYCourseTitleTableCell.h"
#import "CollectionViewLeftOrRightAlignedLayout.h"
#import "MDYSearchHistoryCollectionCell.h"
@interface MDYCourseTitleTableCell ()<HorizontalCollectionLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation MDYCourseTitleTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headImageView.layer setCornerRadius:16];
    
    CollectionViewLeftOrRightAlignedLayout *flowLayout = [[CollectionViewLeftOrRightAlignedLayout alloc] init];
    flowLayout.lineSpacing = 0;
    flowLayout.interitemSpacing = 8;
    flowLayout.stringSpacing = 8;
    flowLayout.delegate = self;
    flowLayout.itemHeight = 22.0f;
    flowLayout.labelFont = KSystemFont(12);
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYSearchHistoryCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYSearchHistoryCollectionCell.class)];
}
#pragma mark - HorizontalCollectionLayoutDelegate
- (NSString *)collectionViewItemSizeWithIndexPath:(NSIndexPath *)indexPath {
    return self.flagArray[indexPath.row];
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.flagArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYSearchHistoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYSearchHistoryCollectionCell.class) forIndexPath:indexPath];
    [cell.layer setCornerRadius:4];
    [cell setClipsToBounds:YES];
    [cell.titleLabel setFont:KSystemFont(12)];
    [cell.titleLabel setTextColor:K_WhiteColor];
    [cell setBackgroundColor:K_MainColor];
    cell.title = self.flagArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}
- (void)setFlagArray:(NSArray *)flagArray {
    _flagArray = flagArray;
    [self.collectionView reloadData];
}
- (void)setDetailModel:(MDYCourseDetailModel *)detailModel {
    _detailModel = detailModel;
    if (detailModel) {
        [self.titleLabel setText:detailModel.c_name];
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.t_img] placeholderImage:[UIImage imageNamed:@"default_avatar_icon"]];
        [self.nameLabel setText:detailModel.t_name];
        [self.noteLabel setText:[NSString stringWithFormat:@"共%@个课时",detailModel.count]];
        if ([detailModel.is_pay integerValue] == 0) {
            [self.moneyLabel setText:@"免费"];
        } else {
            if ([detailModel.is_group integerValue] == 1 || [detailModel.is_seckill integerValue] == 1) {
                NSString *string = detailModel.group_price;
                if ([detailModel.is_seckill integerValue] == 1) {
                    string = detailModel.seckill_price;
                }
                NSString *money = [NSString stringWithFormat:@"¥ %@ ",string];
                NSString *originMoney = [NSString stringWithFormat:@"原价 ¥ %@",detailModel.price];
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:money];
                NSMutableAttributedString *originAttString = [[NSMutableAttributedString alloc] initWithString:originMoney];
                NSRange range = [money rangeOfString:@"¥"];
                if (range.location != NSNotFound) {
                    [attString addAttribute:NSFontAttributeName value:KMediumFont(12) range:range];
                }
                [originAttString addAttribute:NSFontAttributeName value:KSystemFont(12) range:NSMakeRange(0, originMoney.length)];
                [originAttString addAttribute:NSForegroundColorAttributeName value:K_TextLightGrayColor range:NSMakeRange(0, originMoney.length)];
                [originAttString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, originMoney.length)];
                
                [attString appendAttributedString:originAttString];
                [self.moneyLabel setAttributedText:attString];
            } else {
                NSString *string = detailModel.price;
                NSString *money = [NSString stringWithFormat:@"¥ %@ ",string];
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:money];
                NSRange range = [money rangeOfString:@"¥"];
                if (range.location != NSNotFound) {
                    [attString addAttribute:NSFontAttributeName value:KMediumFont(12) range:range];
                }
                [self.moneyLabel setAttributedText:attString];
            }
        }
        self.flagArray = detailModel.biaoqian;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
