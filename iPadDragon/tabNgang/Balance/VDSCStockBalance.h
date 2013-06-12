//
//  VDSCStockBalance.h
//  iPadDragon
//
//  Created by Lion User on 31/01/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDSCStockBalance : UIView<UITableViewDelegate,UITableViewDataSource>

//@property (retain, nonatomic) IBOutlet UIImageView *imageHeader;
@property (retain, nonatomic) IBOutlet UITableView *tableBalance;
@property (retain, nonatomic) IBOutlet UILabel *lb_TongCongGiaTriThiTruong;
@property (retain, nonatomic) IBOutlet UILabel *lb_tongCongKhaNangNhanNo;
@property(retain, nonatomic) id delegate;
-(void) LoadStockBalancce;

@end
