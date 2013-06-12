//
//  VDSCFullPriceBoard_PopoverViewController.h
//  iPadDragon
//
//  Created by vdsc on 1/2/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDSCPriceBoardEntity.h"
#import "VDSCMarketInfo.h"

@interface VDSCFullPriceBoard_PopoverViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *f_ma;
@property (retain, nonatomic) IBOutlet UITextView *f_congTy;
@property (retain, nonatomic) IBOutlet UILabel *f_kl_gia;
@property (retain, nonatomic) IBOutlet UILabel *f_kl_tangGiam;
@property (retain, nonatomic) IBOutlet UILabel *f_thamChieu;
@property (retain, nonatomic) IBOutlet UILabel *f_tran;
@property (retain, nonatomic) IBOutlet UILabel *f_san;
@property (retain, nonatomic) IBOutlet UILabel *f_cao;
@property (retain, nonatomic) IBOutlet UILabel *f_thap;
@property (retain, nonatomic) IBOutlet UILabel *f_trungBinh;
@property (retain, nonatomic) IBOutlet UILabel *f_tongKL;
@property (retain, nonatomic) IBOutlet UIWebView *chart_kl_gia;

@property (strong, nonatomic) VDSCPriceBoardEntity *priceEntity;
-(void)assignDataToControl;
- (IBAction)btn_buy_touch:(id)sender;
- (IBAction)btn_sell_touch:(id)sender;
- (IBAction)btn_add_touch:(id)sender;
- (IBAction)btn_remove_touch:(id)sender;

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) VDSCMarketInfo *marketInfo;
@property (retain, nonatomic) UITableViewCell *currentCell;
@end
