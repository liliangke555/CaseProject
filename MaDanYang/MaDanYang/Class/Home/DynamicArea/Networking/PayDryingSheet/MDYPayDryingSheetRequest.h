//
//  MDYPayDryingSheetRequest.h
//  MaDanYang
//
//  Created by kckj on 2021/8/20.
//

#import "MDYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDYPayDryingSheetRequest : MDYBaseRequest
CopyStringProperty drying_sheet_id;
CopyStringProperty integral_type_id;
@end

@interface MDYPayDryingSheetModel : NSObject
CopyStringProperty msg;
@end

NS_ASSUME_NONNULL_END
