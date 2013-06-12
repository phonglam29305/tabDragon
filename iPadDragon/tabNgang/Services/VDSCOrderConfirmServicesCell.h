//
//  VDSCOrderConfirmServicesCell.h
//  iPadDragon
//
//  Created by vdsc on 4/4/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDSCObjectOrderComfirm.h"

@interface VDSCOrderConfirmServicesCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *lbSTT;

@property (retain, nonatomic) IBOutlet UILabel *lbNgayGD;

@property (retain, nonatomic) IBOutlet UILabel *lbLenh;

@property (retain, nonatomic) IBOutlet UILabel *lbMuaBan;

@property (retain, nonatomic) IBOutlet UILabel *lbLoai;
@property (retain, nonatomic) IBOutlet UILabel *lbSan;
@property (retain, nonatomic) IBOutlet UILabel *lbMaChungKhoan;
@property (retain, nonatomic) IBOutlet UILabel *lbKhoiLuongDat;

@property (retain, nonatomic) IBOutlet UILabel *lbGiaDat;
@property (retain, nonatomic) IBOutlet UILabel *lbKhoiLuongHuy;

-(void)setData2Cell;

@property (strong, nonatomic) VDSCObjectOrderComfirm *Entity;
@property (retain, nonatomic) id delegate;

@end
