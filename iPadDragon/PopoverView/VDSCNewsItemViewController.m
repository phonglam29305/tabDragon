//
//  VDSCNewsItemViewController.m
//  iPadDragon
//
//  Created by vdsc on 4/29/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCNewsItemViewController.h"

@interface VDSCNewsItemViewController ()

@end

@implementation VDSCNewsItemViewController
@synthesize newsEntity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if ((UIDeviceOrientationIsLandscape(toInterfaceOrientation))||(UIDeviceOrientationIsLandscape(toInterfaceOrientation))) {
            return YES;
        }
        else return NO;
    }
    else
    {
        if ((UIDeviceOrientationIsLandscape(toInterfaceOrientation))||(UIDeviceOrientationIsLandscape(toInterfaceOrientation))) {
            return YES;
        }
        else return NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.f_title.text = newsEntity.f_title;
    self.f_date.text = newsEntity.f_date;
    if(newsEntity.isWebLink)
    {
        NSURLRequest *request=[[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:newsEntity.f_content]] autorelease];
       [self.f_webContent loadRequest:request];
    }
    else
        [self.f_webContent loadHTMLString:newsEntity.f_content baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_close_touch:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
