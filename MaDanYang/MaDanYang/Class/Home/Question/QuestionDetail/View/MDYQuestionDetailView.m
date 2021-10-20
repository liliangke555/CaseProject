//
//  MDYQuestionDetailView.m
//  MaDanYang
//
//  Created by kckj on 2021/6/8.
//

#import "MDYQuestionDetailView.h"
#import "MDYImageCollectionCell.h"

@interface MDYQuestionDetailView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation MDYQuestionDetailView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSource = [NSMutableArray array];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(CK_WIDTH);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).mas_offset(24);
            make.left.equalTo(self.mas_left).mas_offset(16);
            make.right.lessThanOrEqualTo(self.mas_right).mas_offset(-10);
        }];
        [titleLabel setText:@"--"];
        [titleLabel setTextColor:K_TextBlackColor];
        [titleLabel setFont:KMediumFont(17)];
        [titleLabel setNumberOfLines:0];
        self.titleLabel = titleLabel;
        
        UILabel *detailLabel = [[UILabel alloc] init];
        [self addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).mas_offset(24);
            make.left.equalTo(self.mas_left).mas_offset(16);
            make.right.lessThanOrEqualTo(self.mas_right).mas_offset(-16);
        }];
        [detailLabel setNumberOfLines:0];
        [detailLabel setText:@"----"];
        [detailLabel setTextColor:K_TextGrayColor];
        [detailLabel setFont:KSystemFont(15)];
        self.detailLabel = detailLabel;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:8];
        [flowLayout setItemSize:CGSizeMake((CK_WIDTH - 32 - 24) / 4.0f, (CK_WIDTH - 32 - 24) / 4.0f)];
        [flowLayout setSectionHeadersPinToVisibleBounds:NO];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 16, 0, 16));
            make.top.equalTo(detailLabel.mas_bottom).mas_offset(24);
            make.height.mas_equalTo((CK_WIDTH - 32 - 24) / 4.0f);
        }];
        [collectionView setBackgroundColor:K_WhiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYImageCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYImageCollectionCell.class)];
        [collectionView.layer setCornerRadius:6];
        [collectionView setClipsToBounds:YES];
        self.collectionView = collectionView;
        
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).mas_offset(16);
            make.top.equalTo(collectionView.mas_bottom).mas_offset(32);
        }];
        [label setTextColor:K_TextBlackColor];
        [label setFont:KMediumFont(17)];
        [label setText:@"回答"];
        
        UIView *view = [[UIView alloc] init];
        [self insertSubview:view atIndex:0];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(label).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(6);
        }];
        [view setBackgroundColor:K_MainColor];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view.mas_bottom).mas_offset(16);
        }];
    }
    return self;
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((CK_WIDTH - 32 - 24) / 4.0f, (CK_WIDTH - 32 - 24) / 4.0f);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYImageCollectionCell.class) forIndexPath:indexPath];
    cell.imageUrl = self.dataSource[indexPath.item];
    [cell showDelete:NO deleteAction:nil];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.reviewImageView) {
        self.reviewImageView(indexPath.item,self.dataSource);
    }
}
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}
- (void)setInfoModel:(MDYPutQuestionInfoModel *)infoModel {
    _infoModel = infoModel;
    if (infoModel) {
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:infoModel.put_txt];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0; // 设置行间距
        paragraphStyle.alignment = NSTextAlignmentJustified; //设置两端对齐显示
        paragraphStyle.lineHeightMultiple = 1.03;
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
        [self.detailLabel setAttributedText:attributedStr];
        
        //富文本属性
        NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
        textDict[NSParagraphStyleAttributeName] = paragraphStyle;
        textDict[NSFontAttributeName] = KSystemFont(15);
        CGFloat height = [infoModel.put_txt getSpaceLabelHeightwithAttrDict:textDict withWidth:CK_WIDTH - 32];
        infoModel.contentHeight  += (height + 24);
        infoModel.contentHeight += (CK_WIDTH - 32 - 24) / 4.0f + 64;
        
        NSArray *array = [infoModel.imgs componentsSeparatedByString:@","];
        self.dataSource = [NSMutableArray arrayWithArray:array];
        [self.titleLabel setText:infoModel.put_title];
    }
}
@end
