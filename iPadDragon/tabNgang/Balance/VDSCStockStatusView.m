//
//  VDSCStockStatusView.m
//  iPadDragon
//
//  Created by Lion User on 23/01/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCStockStatusView.h"

@implementation VDSCStockStatusView
//@synthesize imgHeader;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initControls];
    
}
-(void) initControls
{
     // [self.imgHeader setFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
}
- (void)dealloc {
   
    //[imgHeader release];
    [super dealloc];
}
@end
