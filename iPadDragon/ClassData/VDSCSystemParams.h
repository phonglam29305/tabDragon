//
//  VDSCSystemParams.h
//  iPadDragon
//
//  Created by vdsc on 4/1/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDSCSystemParams : NSObject

@property (strong, nonatomic) NSMutableArray *orderStatusList;
@property (strong, nonatomic) NSMutableArray *hsxOrderType;
@property (strong, nonatomic) NSMutableArray *hnxOrderType;
@property (strong, nonatomic) NSMutableArray *upcomOrderType;
@property (strong, nonatomic) NSMutableArray *hoseStepPrice;
@property (strong, nonatomic) NSMutableArray *hnxStepPrice;
@property (strong, nonatomic) NSMutableArray *upcomStepPrice;
@property (assign, nonatomic) double hoseMaxOrderQty;
@property (assign, nonatomic) double hnxMaxOrderQty;
@property (assign, nonatomic) double upcomMaxOrderQty;


-(NSArray*) getStepPrice:(NSString*)marketId;
-(NSString*) getOrderType:(NSString*)marketId type:(NSString*)type;
-(NSString*) getOrderStatus:(NSString*)status langue:(int)VN0_EN1;
@end
