//
//  VDSCEntitlementEntity.h
//  iPadDragon
//
//  Created by vdsc on 4/26/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDSCEntitlementEntity : NSObject

/*
 ' + stocks[i][0]: Mã CP
 + stocks[i][1]: Tên TV
 + stocks[i][2]: Tên TA
 + stocks[i][3]: Ngày đăng ký cuối cùng
 + stocks[i][4]: Ngày bắt đầu nhận đăng ký Mua
 + stocks[i][5]: Ngày kết thúc
 + stocks[i][6]: Tỷ lệ
 + stocks[i][7]: KL tại thời điểm chốt quyền
 + stocks[i][8]: KL được phép mua
 + stocks[i][9]: KL còn lại có thể mua
 + stocks[i][10]: Giá mua
 + stocks[i][11]: Mã CK quyền
 + stocks[i][12]: LocationId
 + stocks[i][13]: Sàn
 + stocks[i][14]: Mã quyền
 */
@property (retain, nonatomic) NSString *stockId;
@property (retain, nonatomic) NSString *stockName;
@property (retain, nonatomic) NSString *lastRegDate;
@property (retain, nonatomic) NSString *startRegDate;
@property (retain, nonatomic) NSString *endDate;
@property (assign, nonatomic) NSString *ratio;
@property (assign, nonatomic) int currQty;
@property (assign, nonatomic) int roomQty;
@property (assign, nonatomic) int remainQty;
@property (assign, nonatomic) double buyPrice;
@property (retain, nonatomic) NSString *entitlementStock;
@property (retain, nonatomic) NSString *locationId;
@property (retain, nonatomic) NSString *marketId;
@property (retain, nonatomic) NSString *entitlementId;


@property (assign, nonatomic) float amount;
@property (retain, nonatomic) NSString *status;
@property (retain, nonatomic) NSString *note;

@end
