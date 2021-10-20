//
//  MDYChangePhotoTableCell.m
//  MaDanYang
//
//  Created by kckj on 2021/6/18.
//

#import "MDYChangePhotoTableCell.h"
#import "MDYImageCollectionCell.h"
@interface MDYChangePhotoTableCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@end

@implementation MDYChangePhotoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setSeparatorInset:UIEdgeInsetsMake(0, CK_WIDTH, 0, 0)];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:8];
    [flowLayout setItemSize:CGSizeMake((CK_WIDTH - 32 - 24) / 4.0f, (CK_WIDTH - 32 - 24) / 4.0f)];
    [flowLayout setSectionHeadersPinToVisibleBounds:NO];
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYImageCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYImageCollectionCell.class)];
    self.collectionViewHeight.constant = (CK_WIDTH - 32 - 24) / 4.0f + 8;
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count >= self.maxPhoto ? self.dataSource.count : self.dataSource.count + 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYImageCollectionCell.class) forIndexPath:indexPath];
    if (indexPath.item == self.dataSource.count) {
        cell.imageUrl = @"image_add_icon";
        [cell showDelete:NO deleteAction:nil];
    } else {
        [cell.imageView setImage:self.dataSource[indexPath.item]];
        CKWeakify(self);
        [cell showDelete:YES deleteAction:^{
            if (weakSelf.didClickDelete) {
                weakSelf.didClickDelete(indexPath.item);
            }
        }];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.dataSource.count) {
        if (self.didClickAdd) {
            self.didClickAdd();
        }
    } else {
        if (self.didClickReview) {
            self.didClickReview(indexPath.item);
        }
    }
}
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
