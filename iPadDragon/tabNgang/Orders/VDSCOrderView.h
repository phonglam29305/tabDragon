//
//  VDSCOrderView.h
//  iPadDragon
//
//  Created by vdsc on 1/5/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "OCCalendarViewController.h"
#import "CPPickerView.h"
#import "TVPickerView.h"
#import "UIKeyboardCoView.h"
#import "VDSCOrderTypeView.h"
#import "VDSCOTPView.h"

@interface VDSCOrderView : UIView<UIGestureRecognizerDelegate,  UIKeyboardCoViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UIView *orderTab;
@property (retain, nonatomic) IBOutlet UIView *f_datLenh;
@property (retain, nonatomic) IBOutlet UIButton *f_tuNgay;
@property (retain, nonatomic) IBOutlet UIView *f_searchBar;
@property (retain, nonatomic) IBOutlet UIButton *btn_tuNgay;
- (IBAction)btn_tuNgay_Touch:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *txt_tuNgay;
- (IBAction)btn_denNgay:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *txt_denNgay;
@property (retain, nonatomic) IBOutlet UIButton *btn_hieuLuc;
- (IBAction)btn_hieuLuc_touch:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *txt_hieuLuc;
@property (retain, nonatomic) IBOutlet VDSCOrderTypeView *f_loaiLenh;
@property (retain, nonatomic) IBOutlet UIScrollView *scroll_keycorrect;
- (IBAction)txt_ma_ValueChanged:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *txt_ma;
@property (retain, nonatomic) IBOutlet UITextField *txt_khoiLuong;
@property (retain, nonatomic) IBOutlet UITextField *txt_gia;
@property (retain, nonatomic) IBOutlet UITableView *table_todayOderList;


@property (retain, nonatomic) IBOutlet UILabel *f_maCK;
@property (retain, nonatomic) IBOutlet UILabel *f_tenCty;
@property (retain, nonatomic) IBOutlet UILabel *f_kl_gia;
@property (retain, nonatomic) IBOutlet UILabel *f_kl_tangGiam;
@property (retain, nonatomic) IBOutlet UILabel *f_nn_ban;
@property (retain, nonatomic) IBOutlet UILabel *f_min3Thang;
@property (retain, nonatomic) IBOutlet UILabel *f_max3Thang;
@property (retain, nonatomic) IBOutlet UILabel *f_thamChieu;
@property (retain, nonatomic) IBOutlet UILabel *f_tran;
@property (retain, nonatomic) IBOutlet UILabel *f_san;
@property (retain, nonatomic) IBOutlet UILabel *f_cao;
@property (retain, nonatomic) IBOutlet UILabel *f_thap;
@property (retain, nonatomic) IBOutlet UILabel *f_trungBinh;
@property (retain, nonatomic) IBOutlet UILabel *f_tongKL;
@property (retain, nonatomic) IBOutlet UILabel *f_tongGT;
@property (retain, nonatomic) IBOutlet UILabel *f_nngoai_mua;
@property (retain, nonatomic) IBOutlet UILabel *f_nngoai_ban;
@property (retain, nonatomic) IBOutlet UILabel *f_room;
@property (retain, nonatomic) IBOutlet UILabel *f_tongRoom;
@property (retain, nonatomic) IBOutlet UILabel *f_thayDoi;
@property (retain, nonatomic) IBOutlet UILabel *f_minMax_3thang;
@property (retain, nonatomic) IBOutlet UILabel *f_mua3_kl;
@property (retain, nonatomic) IBOutlet UILabel *f_mua3_gia;
@property (retain, nonatomic) IBOutlet UILabel *f_mua2_gia;
@property (retain, nonatomic) IBOutlet UILabel *f_mua2_kl;
@property (retain, nonatomic) IBOutlet UILabel *f_mua1_gia;
@property (retain, nonatomic) IBOutlet UILabel *f_mua1_kl;
@property (retain, nonatomic) IBOutlet UILabel *f_kl_gia_1;
@property (retain, nonatomic) IBOutlet UILabel *f_kl_kl_1;
@property (retain, nonatomic) IBOutlet UILabel *f_ban1_gia;
@property (retain, nonatomic) IBOutlet UILabel *f_ban2_gia;
@property (retain, nonatomic) IBOutlet UILabel *f_ban3_gia;
@property (retain, nonatomic) IBOutlet UILabel *f_ban1_kl;
@property (retain, nonatomic) IBOutlet UILabel *f_ban2_kl;
@property (retain, nonatomic) IBOutlet UILabel *f_ban3_kl;
@property (retain, nonatomic) IBOutlet UITableView *tableNews;
@property (retain, nonatomic) IBOutlet UILabel *process_mua;
@property (retain, nonatomic) IBOutlet UILabel *process_ban;
@property (retain, nonatomic) id delegate;
@property (retain, nonatomic) IBOutlet UILabel *f_tiLeVay;
- (IBAction)btn_OrderConfirm:(id)sender;
//@property (retain, nonatomic) IBOutlet UISegmentedControl *seg_orderSide;
@property (retain, nonatomic) IBOutlet UILabel *f_sucMua;
@property (retain, nonatomic) IBOutlet UILabel *f_soDuCK;
@property (retain, nonatomic) IBOutlet UILabel *f_tongTien;
@property (strong, nonatomic) NSString *stockId;
-(void) loadStockInfo;
@property (retain, nonatomic) IBOutlet VDSCOTPView *otpView;
@property (retain, nonatomic) IBOutlet VDSCOTPView *otp;
- (IBAction)btn_showMatchPriceByTime:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btn_sideOrder;
- (IBAction)btn_sideOrder_touch:(id)sender;
@property (retain, nonatomic) HMSegmentedControl *segmentedControl;
@property (retain, nonatomic) NSMutableArray *arrayGtdDate;
- (IBAction)btn_cancel_touch:(id)sender;
@property (retain, nonatomic) UIPopoverController *popoverController;
-(void)loadOrders;
-(void)clearInputData;


@end
