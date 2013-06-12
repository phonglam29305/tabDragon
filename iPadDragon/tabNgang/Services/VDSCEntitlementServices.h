//
//  VDSCEntitlementServices.h
//  iPadDragon
//
//  Created by Lion User on 04/04/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCalendarViewController.h"
#import "VDSCEntitlementEntity.h"

@interface VDSCEntitlementServices : UIView<UITableViewDataSource,UITableViewDelegate,OCCalendarDelegate>
@property (retain, nonatomic) IBOutlet UIButton *btn_DenNgay;

- (IBAction)btn_DenNgay_touch:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *txtDenNgay;
@property (retain, nonatomic) IBOutlet UIButton *btn_TuNgay;
- (IBAction)btn_TuNgay_touch:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *txtTuNgay;

- (IBAction)btn_MaCK_touch:(id)sender;
-(void)setData2Controls;
@property (retain, nonatomic) IBOutlet UITableView *tableList;

@property (retain, nonatomic) IBOutlet UIButton *btn_MaCK;
@property (retain, nonatomic) UIPopoverController *popoverController;
@property (retain, nonatomic) IBOutlet UILabel *f_stockName;
@property (retain, nonatomic) IBOutlet UILabel *f_endDate;
@property (retain, nonatomic) IBOutlet UILabel *f_startRegDate;
@property (retain, nonatomic) IBOutlet UILabel *f_endRegDate;
@property (retain, nonatomic) IBOutlet UILabel *f_ratio;
@property (retain, nonatomic) IBOutlet UILabel *f_currQty;
@property (retain, nonatomic) IBOutlet UILabel *f_buyPrice;
@property (retain, nonatomic) IBOutlet UILabel *f_roomQty;
@property (retain, nonatomic) IBOutlet UILabel *f_remainQty;
@property (retain, nonatomic) IBOutlet UITextField *txt_regQty;
@property (retain, nonatomic) IBOutlet UILabel *f_amount;
- (IBAction)txt_regQty_change:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *otpView;
@property (strong, nonatomic) VDSCEntitlementEntity *entitlementEntity;
- (IBAction)btn_confirm_touch:(id)sender;
- (IBAction)btn_cancel_touch:(id)sender;
- (IBAction)btn_refresh_touch:(id)sender;
- (void)registerForKeyboardNotifications;
-(void)unregisterForKeyboardNotifications;
@end
