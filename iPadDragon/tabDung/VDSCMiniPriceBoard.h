//
//  VDSCMiniPriceBoard.h
//  iPadDragon
//
//  Created by vdsc on 1/4/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDSCPriceBoardEntity.h"

@interface VDSCMiniPriceBoard : UIView<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *priceBoard;
- (IBAction)showFullPriceBoard:(id)sender;
- (IBAction)f_keyWordValueChange:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *f_keyWord;
@property (retain, nonatomic) IBOutlet UILabel *f_maCK;
@property (retain, nonatomic) IBOutlet UITextView *f_tenCty;
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
@property (retain, nonatomic) IBOutlet UILabel *f_cao52Tuan;
@property (retain, nonatomic) IBOutlet UILabel *f_thap52Tuan;
@property (retain, nonatomic) IBOutlet UILabel *f_nngoai_mua;
@property (retain, nonatomic) IBOutlet UILabel *f_room;
@property (retain, nonatomic) IBOutlet UILabel *f_tangGiam1Tuan;
@property (retain, nonatomic) IBOutlet UILabel *f_tangGiam1Thang;
@property (retain, nonatomic) IBOutlet UILabel *f_tangGiam3thang;
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
@property (retain, nonatomic) IBOutlet UIWebView *char_kl_gia;
@property (retain, nonatomic)NSTimer *timer_price;
@property (retain, nonatomic)NSTimer *timer_detail;
@property (retain, nonatomic) IBOutlet UISegmentedControl *seq_chartType;

//@property (strong, nonatomic) VDSCMarketInfo *market;
- (IBAction)btn_buy_touch:(id)sender;
- (IBAction)btn_sell_touch:(id)sender;
- (IBAction)btn_add_touch:(id)sender;
- (IBAction)btn_remove_touch:(id)sender;
-(void)loadPriceBoard;

@property (strong, nonatomic) VDSCPriceBoardEntity *stockEntity;
@property (strong, nonatomic) NSMutableArray *array_price_change;
@property (strong, nonatomic) NSMutableArray *root_array_price;
@property (strong, nonatomic) NSMutableArray *array_price;
@property (assign, nonatomic) bool loadFull;
@property (retain, nonatomic) IBOutlet UIView *view_chart;
- (IBAction)tab_changed:(id)sender;
@property (retain, nonatomic) IBOutlet UIWebView *chart_matchedbyTime;
@property (retain, nonatomic) IBOutlet UITableView *table_chiTietKL;
@property (retain, nonatomic) IBOutlet UIView *view_chiTietKL;
@property (strong, nonatomic) id delegate;
@end
