//
//  MDYMyGoodsGroupRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/12.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYMyGoodsGroupRequest : MDYBaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger limit;
//CopyStringProperty type;
//CopyStringProperty group_id;
//CopyStringProperty group_goods_id;
CopyStringProperty a_id;
@end

@interface MDYMyGoodsGroupModel : NSObject
//CopyStringProperty group_kaituan_id;
//CopyStringProperty userlist;

CopyStringProperty pintuan_id;
CopyStringProperty group_id;
CopyStringProperty head_nickname;
CopyStringProperty head_member_img;


@end

@interface MDYMyGoodsGroupListModel : NSObject
StrongProperty NSArray <MDYMyGoodsGroupModel *>*data;
AssignProperty NSInteger key;
@end

NS_ASSUME_NONNULL_END
