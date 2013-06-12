//
//  VDSCOnlineCashTransferViewController.h
//  iPadDragon
//
//  Created by vdsc on 4/3/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDSCOrderEntity.h"

@interface VDSCOrderMatchPriceByTimeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *table_accList;
@property (strong, nonatomic) VDSCOrderEntity *orderEntity;
@end
