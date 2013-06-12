//
//  VDSCPush2DateListViewController.h
//  iPadDragon
//
//  Created by vdsc on 4/14/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDSCPush2DateListViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (retain, nonatomic) IBOutlet UIPickerView *picker_dateList;
@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) NSMutableArray *array_TKUQ;
@property (strong, nonatomic) NSMutableArray *array_agent;
@end
