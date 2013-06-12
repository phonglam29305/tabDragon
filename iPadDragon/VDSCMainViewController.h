//
//  VDSCMainViewController.h
//  iPadDragon
//
//  Created by vdsc on 12/24/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDSCMarketInfo.h"
#import "VDSCListView.h"
#import "VDSCMiniPriceBoard.h"
#import "VDSCViewController.h"
#import "VDSCNewsView.h"
#import "VDSCOrderView.h"
#import "VDSCAccountInfoView.h"
#import "VDSCCashTranferServices.h"
#import "VDSCBusinessNewsView.h"
#import "VDSCMarketIndexView.h"
#import "VDSCBalanceView.h"

@interface VDSCMainViewController : UIViewController

@property (retain, nonatomic) VDSCMarketInfo *market;
@property (assign, nonatomic) VDSCListView *list;
@property (assign, nonatomic) VDSCMiniPriceBoard *miniPriceBoard;
@property (assign, nonatomic) VDSCBusinessNewsView *businessNews;
@property (assign, nonatomic) VDSCNewsView *news;
@property (assign, nonatomic) VDSCOrderView *order;
@property (assign, nonatomic) VDSCBalanceView *balance;
@property (assign, nonatomic) VDSCCashTranferServices *services;
@property (assign, nonatomic) VDSCAccountInfoView *accountInfo;
@property (retain, nonatomic) IBOutlet UIView *bg_menuBackground;
@property (retain, nonatomic) IBOutlet UIButton *btn_order;
@property (retain, nonatomic) IBOutlet UIButton *btn_list;
@property (retain, nonatomic) IBOutlet UIButton *btn_balance;
@property (retain, nonatomic) IBOutlet UIButton *btn_services;
@property (retain, nonatomic) IBOutlet UILabel *lbl_cusName;
@property (retain, nonatomic) IBOutlet UIWebView *f_marqueeIndex;
@property (retain, nonatomic) UIPopoverController *popoverOrderController;

@property (assign, nonatomic) IBOutlet UIView *mainView;
@property (assign, nonatomic) IBOutlet UIView *headerView;
@property (assign, nonatomic) int defaultTab_0market_1order_2services_3list_4balance_5account;
- (IBAction)tabMarketView:(id)sender;
- (IBAction)tabNewsView:(id)sender;
- (IBAction)tabBusinessNewsView:(id)sender;
- (IBAction)tabOrderView:(id)sender;
- (IBAction)tabListView:(id)sender;
- (IBAction)tabBalanceView:(id)sender;
- (IBAction)tabServiceView:(id)sender;
- (IBAction)tabAccountInfoView:(id)sender;
- (IBAction)exit:(id)sender;

- (IBAction)btn_buy_touch:(id)sender;
- (IBAction)btn_sell_touch:(id)sender;
- (IBAction)btn_cancel_touch:(id)sender;
- (IBAction)btn_edit_touch:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btn_buy;
@property (retain, nonatomic) IBOutlet UIButton *btn_sell;
@property (retain, nonatomic) IBOutlet UIButton *btn_cancel;
@property (retain, nonatomic) IBOutlet UIButton *btn_edit;

@property (retain, nonatomic) IBOutlet UIView *view_footer;
@property (retain, nonatomic) IBOutlet UIButton *btn_accountInfo;
@property (retain, nonatomic) IBOutlet UIButton *btn_market;
@property (retain, nonatomic) IBOutlet UIButton *btn_businessNews;
@property (retain, nonatomic) IBOutlet UIButton *btn_VDSCNews;
@property(strong, nonatomic) VDSCViewController *splashView;
@property (strong, nonatomic) VDSCMarketIndexView *marketIndex;
@property (strong, nonatomic) VDSCCommonUtils *utils;
-(void)showDefaultTab;
@property (strong, nonatomic) NSString *stockId;
@property (assign, nonatomic) double priceOrder;
@property (strong, nonatomic) NSString *orderSide;
-(void)showOrderView:(UIView*)sender orderEntity:(id)orderEntity  inView:(UIView*)inView;
-(NSString*)getMarketByStock: (NSString*)stockId;
-(BOOL)checkStockInWatchingList:(NSString*)stockId;

- (IBAction)btn_infoView_touch:(id)sender;
@property (retain, nonatomic) NSMutableArray *array_watchList;
-(void) loadWatchingStocks;
-(void) addRemoveStockInWatchingList:(BOOL)isAdd stockId:(NSString*) stockId marketId:(NSString*)marketId;
@property (strong, nonatomic) UIView *activeView;

@end
