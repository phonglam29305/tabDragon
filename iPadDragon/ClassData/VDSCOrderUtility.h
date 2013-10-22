//
//  VDSCOrderUtility.h
//  iPadDragon
//
//  Created by vdsc on 4/21/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDSCCommonUtils.h"
#import "VDSCPriceBoardEntity.h"
#import "VDSCSystemParams.h"
#import "VDSCOTPView.h"


@interface VDSCOrderUtility : NSObject

-(NSString*)getErrorMessage:(NSString*)errCode;
@property (strong, nonatomic) VDSCCommonUtils *utils;
@property (retain, nonatomic) id delegate;

- (BOOL)sendOrder:(NSString*)orderType stockEntity:(VDSCPriceBoardEntity*)stockEntity params:(VDSCSystemParams*)params orderSide:(NSString*)orderSide price:(double)price qty:(double)qty amountWithFee:(double)amountWithFee isGtdOrder:(BOOL)isGtdOrder gtdDate:(NSString*)gtdDate otpView:(VDSCOTPView*)otpView;

-(NSString*)checkOrderMarket:(NSString*)orderType marketId:(NSString*)marketId stockCode:(NSString*)stockCode orderSide:(NSString*)orderSide;
@end
