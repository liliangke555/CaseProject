//
//  MDYSearchResultTableCell.h
//  MaDanYang
//
//  Created by kckj on 2021/6/5.
//

#import <UIKit/UIKit.h>
#import "MDYFreeCourseRequest.h"
#import "MDYAllCourseRequest.h"
#import "MDYCourseGoodsReqeust.h"
#import "MDYAllGoodsRequest.h"
#import "MDYGoodsTimeKillRequest.h"
#import "MDYCurriculumSeckillReqeust.h"
#import "MDYCurriculumGroupRequest.h"
#import "MDYSearchCurriculumRequest.h"
#import "MDYSearchGoodsRequest.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM (NSInteger) {
    MDYCurriculumTypeOfNormal  = 0, //普通
    MDYCurriculumTypeOfGroup     = 2, // 拼团
    MDYCurriculumTypeOfTime      = 1, // 秒杀
}MDYCurriculumType;
@interface MDYSearchResultTableCell : UITableViewCell
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) MDYCurriculumType type;

@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *noteString;

@property (nonatomic, strong) MDYFreeCourseModel *courseModel;
@property (nonatomic, assign, getter=isExlusiveCourse) BOOL exlusiveCourse;
@property (nonatomic, strong) MDYAllCourseModel *allCourseModel;
@property (nonatomic, strong) MDYCourseGoodsModel *courseGoodsModel;
@property (nonatomic, strong) MDYAllGoodsModel *allGoodsModel;
@property (nonatomic, strong) MDYGoodsTimeKillModel *timeModel;

@property (nonatomic, strong) MDYCurriculumSeckillModel *sourseKillModel;
@property (nonatomic, strong) MDYCurriculumGroupModel *courseGroupModel;
@property (nonatomic, strong) MDYSearchCurriculumModel *searchCourseModel;
@property (nonatomic, strong) MDYSearchGoodsModel *searchGoodsModel;

@property (nonatomic, assign, getter=isHiddenNote) BOOL hiddenNote;
@end

NS_ASSUME_NONNULL_END
