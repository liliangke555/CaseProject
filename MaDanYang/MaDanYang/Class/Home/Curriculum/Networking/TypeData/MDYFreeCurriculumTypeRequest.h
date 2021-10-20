//
//  MDYFreeCurriculumTypeRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/7/9.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYFreeCurriculumTypeRequest : MDYBaseRequest

@end

@interface MDYFreeCurriculumTypeModel : NSObject
CopyStringProperty uid;
CopyStringProperty name;
CopyStringProperty img;
@end

NS_ASSUME_NONNULL_END
