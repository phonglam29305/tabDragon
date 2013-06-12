//
//  VDSCMachedOrderView.h
//  iPadDragon
//
//  Created by vdsc on 1/9/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCalendarViewController.h"
#import "VDSCSystemParams.h"

@interface VDSCMachedOrderView : UIView<OCCalendarDelegate,UITableViewDataSource, UITableViewDelegate>

- (IBAction)btn_fDate_touch:(id)sender;
- (IBAction)btn_tDate_touch:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *table_orderList;
@property (retain, nonatomic) IBOutlet UITextField *txt_tDate;
- (IBAction)btn_phi_touch:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *txt_fDate;
- (IBAction)btn_thue_touch:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lbl_thue;
@property (retain, nonatomic) IBOutlet UILabel *lbl_phi;
- (IBAction)btn_loadData_touch:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lbl_ngayGD;
@property (retain, nonatomic) IBOutlet UITextField *txt_stock;
- (IBAction)btn_ngayGD_touch:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *searchBar;
@property (strong, nonatomic) VDSCSystemParams *params;
@end
