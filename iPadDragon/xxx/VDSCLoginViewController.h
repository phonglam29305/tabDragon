//
//  VDSCLoginViewController.h
//  iPadDragon
//
//  Created by vdsc on 12/24/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDSCViewController.h"

@interface VDSCLoginViewController : UIViewController
@property (weak, nonatomic) VDSCViewController *splash;
- (IBAction)login:(id)sender;
@end
