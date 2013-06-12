//
//  VDSCLogin.m
//  iPadDragon
//
//  Created by vdsc on 12/26/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import "VDSCLogin.h"
#import "VDSCViewController.h"

@implementation VDSCLogin

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSURL* aURL = [NSURL URLWithString:@"https://online.vdsc.com.vn/randomImage.jpg?0.34593450394853"];
    NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
    [[self capcha] setImage:[UIImage imageWithData:data]];
}
- (IBAction)btnLogin:(id)sender {
    //[self setHidden:YES];
    [(VDSCViewController *)self.window.rootViewController hideLoginView];
    //[(VDSCViewController *)[[self.superview viewWithTag:10] nextResponder] hideLoginView];
}
@end
