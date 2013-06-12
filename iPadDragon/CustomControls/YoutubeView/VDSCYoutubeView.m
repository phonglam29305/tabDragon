//
//  VDSCYoutubeView.m
//  iPadDragon
//
//  Created by vdsc on 1/14/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCYoutubeView.h"

@implementation VDSCYoutubeView

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
- (VDSCYoutubeView *)initWithStringAsURL:(NSString *)urlString frame:(CGRect)frame;
{
    if (self = [super init])
    {
        // Create webview with requested frame size
        self = [[VDSCYoutubeView alloc] initWithFrame:frame];
        
        // HTML to embed YouTube video
        NSString *youTubeVideoHTML = @"<html><head></head><body style=\"margin:0\"><iframe width=\" %f \" height=\" %f \" src=\" %@ \" frameborder=\"0\" allowfullscreen></iframe></body></html>";
        
        /// Populate HTML with the URL and requested frame size
        NSString *html = [NSString stringWithFormat:youTubeVideoHTML, frame.size.width, frame.size.height, urlString];
        
        // Load the html into the webview
        [self loadHTMLString:html baseURL:nil];
    }
    return self;
}

@end
