//
//  MDYUserModel.h
//  MaDanYang
//
//  Created by kckj on 2021/7/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDYUserModel : NSObject
CopyStringProperty phone;
CopyStringProperty headimgurl;
CopyStringProperty nickname;
CopyStringProperty integral;

CopyStringProperty sex;
CopyStringProperty identity;
CopyStringProperty enterprise_name;
CopyStringProperty enterprise_add;
CopyStringProperty enterprise_type;
CopyStringProperty enterprise_img;

AssignProperty BOOL is_weixin;

@end

NS_ASSUME_NONNULL_END
