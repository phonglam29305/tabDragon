//
//  VDSCMachedOrderView.h
//  iPadDragon
//
//  Created by vdsc on 1/9/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCalendarViewController.h"

@interface VDSCOrderHistoryView : UIView<OCCalendarDelegate,UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *table_todayOderList;
@property (retain, nonatomic) IBOutlet UITextField *txt_fDate;
- (IBAction)btn_fDate_touch:(id)sender;
- (IBAction)btn_tDate_touch:(id)sender;
- (IBAction)btn_loadData:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *txt_tDate;
@property (retain, nonatomic) IBOutlet UITextField *txt_stock;

@property (retain, nonatomic) IBOutlet UIView *searchBar;
@end
