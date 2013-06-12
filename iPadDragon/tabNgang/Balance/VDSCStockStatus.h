//
//  VDSCStockStatus.h
//  iPadDragon
//
//  Created by Lion User on 02/02/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDSCStockStatus : UIView<UITableViewDelegate,UITableViewDataSource>

//@property (retain, nonatomic) IBOutlet UIImageView *imageHeader;
@property (retain, nonatomic) IBOutlet UITableView *tableStockStaus;
@property(retain, nonatomic) id delegate;
-(void) LoadStockStatus;

@end
