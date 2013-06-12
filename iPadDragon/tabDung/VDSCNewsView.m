//
//  VDSCNewsView.m
//  iPadDragon
//
//  Created by vdsc on 1/5/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCNewsView.h"
#import "VDSCYoutubeView.h"
#import "VDSCMarketIndexView.h"

@implementation VDSCNewsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) awakeFromNib
{
    [super awakeFromNib];
    
    NSString *html = @"<html><head></head><body style=\"margin:0\"><iframe width=\" %f \" height=\" %f \" src=\" %@ \" frameborder=\"0\" allowfullscreen></iframe></body></html>";
    html = [NSString stringWithFormat:html, self.f_videoFram.frame.size.width, self.f_videoFram.frame.size.height, @"http://www.youtube.com/embed/6Hq2AHWIv1E"];
    [self.f_videoFram loadHTMLString:html baseURL:nil];
}
-(void) loadView
{
    self.f_videoFram = [[VDSCYoutubeView alloc]
                        initWithStringAsURL:@"http://www.youtube.com/embed/6Hq2AHWIv1E"
                        frame:self.f_videoFram.frame];
}

- (void)dealloc {
    [_f_videoFram release];
    //[_marketInfo release];
    [super dealloc];
}
@end
