//
//  VDSCCommonUtils.h
//  iPadDragon
//
//  Created by vdsc on 1/4/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDSCClientInfo.h"
#import "VDSCStock4OrderEntity.h"

@interface VDSCCommonUtils : NSObject

@property (retain, nonatomic) NSNumberFormatter *numberFormatter;
@property (retain, nonatomic) NSNumberFormatter *numberFormatter1Digits;
@property (retain, nonatomic) NSNumberFormatter *numberFormatter2Digits;
@property (retain, nonatomic) NSNumberFormatter *numberFormatter3Digits;
@property (retain, nonatomic) NSDateFormatter* shortDateFormater;
@property (retain, nonatomic) NSDateFormatter* longDateFormater;
@property (retain, nonatomic) UIColor *c_tran;
@property (retain, nonatomic) UIColor *c_san;
@property (retain, nonatomic) UIColor *c_thamChieu;
@property (retain, nonatomic) UIColor *c_koThayDoi;
@property (retain, nonatomic) UIColor *c_tang;
@property (retain, nonatomic) UIColor *c_giam;

@property (retain, nonatomic) VDSCClientInfo *clientInfo;
@property (strong, nonatomic) NSString *soapMessage;

@property (strong, nonatomic) NSString *passExecutePrefix;
@property (strong, nonatomic) NSString *keyParaValue;
@property (strong, nonatomic) NSString *keyParaKey;

-(VDSCCommonUtils *) init;
-(void) setLabelColor: (NSString *)color label:(UILabel *)label;
-(UIColor*) getColor:(NSString*)color;
-(NSDictionary*) getDataFromUrl:(NSString *)url method:(NSString*)method postData:(NSString*)postData;
-(NSString*) postValueBuilder:(NSArray*)params;
-(NSArray*)OTPRandomPosition;
-(NSArray*)getOPTPosition: (NSString*)OTPPosition1 OTPPosition2:(NSString*)OTPPosition2;
-(BOOL)otpCherker:(NSString*)OTPPosition1 OTPPosition2:(NSString*)OTPPosition2  OTPPosition1_Value:(NSString*)OTPPosition1_Value OTPPosition2_value:(NSString*)OTPPosition2_Value isSave:(BOOL)isSave;
-(void)showMessage:(NSString*)messageCaption messageContent:(NSString*)messageContent;
-(void)showMessage:(NSString*)messageCaption messageContent:(NSString*)messageContent dismissAfter:(int)dismissAfter;
- (IBAction) showConfirmMessae:(id)sender delegate:(id)delegate message:(NSString*)message;
-(void)addStock2WatchingList:(NSString*) stockId marketId:(NSString*) marketId;
-(void)removeStock2WatchingList:(NSString*) stockId marketId:(NSString*) marketId;
-(VDSCStock4OrderEntity*) loadStockInfo:(NSString*)stockId marketId:(NSString*) marketId orderSide:(NSString*)orderSide;
@property (assign, nonatomic) int rowHeight;
@property (assign, nonatomic) CGFloat fontSize;
@property (assign, nonatomic) NSString *fontFamily;
@property (strong, nonatomic) UIColor *cellBackgroundColor;
@property (strong, nonatomic) UIColor *headerBackgroundColor;
-(UIWebView*)showLoading:(UIView*)onView;
-(BOOL) NSStringIsValidEmail:(NSString *)checkString;

@property (strong, nonatomic) id delegate;
@property (retain, nonatomic) NSMutableDictionary *dic_language;

@end
