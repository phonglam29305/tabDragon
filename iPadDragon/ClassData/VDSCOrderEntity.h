//
//  VDSCOrderEntity.h
//  iPadDragon
//
//  Created by vdsc on 3/28/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDSCOrderEntity : NSObject

@property (retain, nonatomic) id orderId;
@property (retain, nonatomic) id orderGroupId;
@property (retain, nonatomic) NSString *marketId;
@property (retain, nonatomic) NSString *stockId;
@property (retain, nonatomic) NSString *side;
@property (assign, nonatomic) double price;
@property (assign, nonatomic) double qty;
@property (assign, nonatomic) double wQty;
@property (assign, nonatomic) double mQty;
@property (assign, nonatomic) double avgMPrice;
@property (retain, nonatomic) NSString *status;
@property (retain, nonatomic) NSString *type;
@property (retain, nonatomic) NSString *gtd;
@property (retain, nonatomic) NSString *time;
@property (retain, nonatomic) NSString *isCancel;
@property (retain, nonatomic) NSString *isEdit;
@property (strong, nonatomic) NSString *order_chanel;

@end
