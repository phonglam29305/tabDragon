//
//  VDSCListView.h
//  iPadDragon
//
//  Created by vdsc on 12/25/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCalendarViewController.h"

@interface VDSCListView : UIView<UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UILabel *f_maCK;
@property (retain, nonatomic) IBOutlet UILabel *f_tongKL;
@property (retain, nonatomic) IBOutlet UILabel *f_giaVon;
@property (retain, nonatomic) IBOutlet UILabel *f_giaTT;
@property (retain, nonatomic) IBOutlet UILabel *f_tien;
@property (retain, nonatomic) IBOutlet UILabel *f_tiLe;
@property (retain, nonatomic) IBOutlet UILabel *f_chotLoi;
@property (retain, nonatomic) IBOutlet UILabel *f_catLo;
@property (retain, nonatomic) IBOutlet UILabel *f_giaTriTT;
@property (retain, nonatomic) IBOutlet UILabel *f_giaTriVon;
@property (retain, nonatomic) IBOutlet UITableView *table_list;
@property (retain, nonatomic) IBOutlet UILabel *f_tongCongTT;
@property (retain, nonatomic) IBOutlet UILabel *f_tongCong;
@property (retain, nonatomic) IBOutlet UILabel *f_giaTriLoiLo;
@property (retain, nonatomic) IBOutlet UILabel *f_tiLeLoiLo;
@property (retain, nonatomic) IBOutlet UILabel *f_thietLap;
@property (retain, nonatomic) IBOutlet UIPopoverController *popover;
-(void)loadData;
@property (strong, nonatomic) id delegate;
@property (retain, nonatomic) IBOutlet UILabel *f_tongCong_text;

@property (strong, nonatomic) NSTimer *timer;
@end
