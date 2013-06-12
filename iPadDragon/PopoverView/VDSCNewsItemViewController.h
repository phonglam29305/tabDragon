//
//  VDSCNewsItemViewController.h
//  iPadDragon
//
//  Created by vdsc on 4/29/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDSCNewsEntity.h"

@interface VDSCNewsItemViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *f_title;
@property (retain, nonatomic) IBOutlet UILabel *f_date;
@property (retain, nonatomic) IBOutlet UIWebView *f_webContent;
@property (retain, nonatomic) VDSCNewsEntity *newsEntity;
- (IBAction)btn_close_touch:(id)sender;
@end
