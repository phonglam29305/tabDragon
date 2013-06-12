//
//  VDSCPriceListViewController.h
//  iPadDragon
//
//  Created by vdsc on 1/10/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDSCMarketInfo.h"

@interface VDSCPriceListViewController : UIViewController<UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate>


@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) VDSCMarketInfo *marketInfo;
@property (assign, nonatomic) int type_1list_2category;


@end
