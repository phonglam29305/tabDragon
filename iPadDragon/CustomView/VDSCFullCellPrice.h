//
//  VDSCFullCellPriceCell.h
//  iPadDragon
//
//  Created by vdsc on 12/27/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDSCPriceBoardEntity.h"
#import "VDSCMainViewController.h"

@interface VDSCFullCellPrice : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *f_ma;

@property (retain, nonatomic) UIPopoverController *popover;

@property (strong, nonatomic) IBOutlet UILabel *f_mua3_gia;
@property (strong, nonatomic) IBOutlet UILabel *f_mua3_kl;
@property (strong, nonatomic) IBOutlet UILabel *f_mua2_gia;
@property (strong, nonatomic) IBOutlet UILabel *f_mua2_kl;
@property (strong, nonatomic) IBOutlet UILabel *f_mua1_gia;
@property (strong, nonatomic) IBOutlet UILabel *f_mua1_kl;

@property (strong, nonatomic) IBOutlet UILabel *f_kl_gia;
@property (strong, nonatomic) IBOutlet UILabel *f_kl_kl;
@property (strong, nonatomic) IBOutlet UILabel *f_kl_tangGiam;
@property (strong, nonatomic) IBOutlet UILabel *f_kl_tongKL;

@property (strong, nonatomic) IBOutlet UILabel *f_ban1_gia;
@property (strong, nonatomic) IBOutlet UILabel *f_ban1_kl;
@property (strong, nonatomic) IBOutlet UILabel *f_ban2_gia;
@property (strong, nonatomic) IBOutlet UILabel *f_ban2_kl;
@property (strong, nonatomic) IBOutlet UILabel *f_ban3_gia;
@property (strong, nonatomic) IBOutlet UILabel *f_ban3_kl;
@property (retain, nonatomic) IBOutlet UILabel *f_nnMua;
@property (retain, nonatomic) IBOutlet UILabel *f_nnBan;
- (IBAction)btn_showDetail:(id)sender;

@property (strong, nonatomic) VDSCPriceBoardEntity *cellData;
@property (strong, nonatomic) id delegate;

-(void) setCellValue:(VDSCPriceBoardEntity *) price;
//-(void) checkDataChanged: (VDSCPriceBoardEntity *) priceEntity;
//-(void) highlightLabel:(UILabel *) label;

@end
