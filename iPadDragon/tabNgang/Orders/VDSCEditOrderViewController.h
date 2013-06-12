//
//  VDSCEditOrderViewController.h
//  iPadDragon
//
//  Created by vdsc on 3/29/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDSCOrderEntity.h"
#import "VDSCSystemParams.h"
#import "VDSCOTPView.h"
#import "VDSCOrderTypeView.h"
#import "UIKeyboardCoView.h"

@interface VDSCEditOrderViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UILabel *f_maCK;
@property (retain, nonatomic) IBOutlet UITextView *f_tenCK;
@property (retain, nonatomic) IBOutlet UILabel *f_gia;
@property (retain, nonatomic) IBOutlet UILabel *f_khoiLuong;
@property (retain, nonatomic) IBOutlet UILabel *f_loaiLenh;
@property (retain, nonatomic) IBOutlet UILabel *f_title;
@property (retain, nonatomic) IBOutlet UITextField *txt_newPrice;
@property (strong, nonatomic) VDSCOrderEntity *orderEntity;
@property (retain, nonatomic) IBOutlet UIView *otpView_cancelEdit;
@property (retain, nonatomic) IBOutlet UIView *otpView_createOrder;
@property (assign, nonatomic) NSString *orderSide;
@property (strong, nonatomic) VDSCSystemParams *params;
@property (retain, nonatomic) IBOutlet UIView *view_orderList;
@property (retain, nonatomic) IBOutlet UIView *view_createOrder;
@property (retain, nonatomic) IBOutlet UIView *view_cancelEdit;
@property (strong, nonatomic) id delegate;
@property (retain, nonatomic) IBOutlet UITableView *table_todayOderList;
@property (retain, nonatomic) IBOutlet UILabel *lbl_cancelEdit;


@property (retain, nonatomic) IBOutlet UIButton *btn_sideOrder;
@property (retain, nonatomic) IBOutlet UILabel *f_sucMua;
@property (retain, nonatomic) IBOutlet UILabel *f_soDuCK;
@property (retain, nonatomic) IBOutlet UILabel *f_tongTien;
@property (retain, nonatomic) IBOutlet UITextField *txt_ma;
@property (retain, nonatomic) IBOutlet UITextField *txt_khoiLuong;
@property (retain, nonatomic) IBOutlet UITextField *txt_gia;
@property (retain, nonatomic) IBOutlet UIButton *btn_hieuLuc;
@property (retain, nonatomic) IBOutlet UILabel *f_tiLeVay;
@property (retain, nonatomic) IBOutlet UITextField *txt_hieuLuc;
@property (retain, nonatomic) IBOutlet VDSCOrderTypeView *f_loaiLenh_createOrder;
//@property (retain, nonatomic) IBOutlet UIKeyboardCoView *scroll_keycorrect;
@property (strong, nonatomic) NSMutableArray *arrayGtdDate;

- (IBAction)btn_confirm_touch:(id)sender;
- (IBAction)btn_cancel_touch:(id)sender;
- (IBAction)btn_hieuLuc_touch:(id)sender;
- (IBAction)btn_sideOrder_touch:(id)sender;
- (IBAction)btn_cancelOrder_cancel_touch:(id)sender;
- (IBAction)btn_cancelOrder_Confirm:(id)sender;
-(void) initLayout;
- (IBAction)txt_ma_ValueChanged:(id)sender;

-(void)loadOrders;
-(void)clearInputData;
@end
