//
//  VDSCInfoViewController.m
//  iPadDragon
//
//  Created by vdsc on 5/24/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCInfoViewController.h"

@interface VDSCInfoViewController ()

@end

@implementation VDSCInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lbl_infoText release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLbl_infoText:nil];
    [super viewDidUnload];
}
@end
