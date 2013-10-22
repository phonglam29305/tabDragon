//
//  VDSCSystemParams.h
//  iPadDragon
//
//  Created by vdsc on 4/1/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDSCSystemParams : NSObject

@property (retain, nonatomic) NSMutableArray *orderStatusList;
@property (retain, nonatomic) NSMutableArray *hsxOrderType;
@property (retain, nonatomic) NSMutableArray *hnxOrderType;
@property (retain, nonatomic) NSMutableArray *upcomOrderType;
@property (retain, nonatomic) NSMutableArray *hoseStepPrice;
@property (retain, nonatomic) NSMutableArray *hnxStepPrice;
@property (retain, nonatomic) NSMutableArray *upcomStepPrice;
@property (assign, nonatomic) double hoseMaxOrderQty;
@property (assign, nonatomic) double hnxMaxOrderQty;
@property (assign, nonatomic) double upcomMaxOrderQty;


@property (assign, nonatomic) double timeChangePriceboard;
@property (assign, nonatomic) double timeChangeOnlineData;
@property (assign, nonatomic) NSString *ternLink;
@property (assign, nonatomic) NSString *supportLink;
@property (assign, nonatomic) NSString *instructionLink;
@property (assign, nonatomic) NSString *marketStatus;

-(NSArray*) getStepPrice:(NSString*)marketId;
-(NSString*) getOrderType:(NSString*)marketId type:(NSString*)type;
-(NSString*) getOrderStatus:(NSString*)status langue:(int)VN0_EN1;

@end
