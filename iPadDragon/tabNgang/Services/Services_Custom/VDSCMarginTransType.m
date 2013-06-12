//
//  VDSCMarginTransType.m
//  iPadDragon
//
//  Created by vdsc on 4/5/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCMarginTransType.h"

@interface VDSCMarginTransType()
{
    NSArray* arr;
}
@end

@implementation VDSCMarginTransType


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled=YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

-(void) InitSource: (NSArray*) source
{
    if(source.count==0)return;
    
    self.TransType = [source objectAtIndex:0];
    arr = source;
    self.contentSize = CGSizeMake(self.frame.size.width*source.count, self.frame.size.height);
    int i=100;
    for(NSString *item in source)
    {
        CGRect rect = self.frame;
        int index = [source indexOfObject:item];
        rect.origin.x = rect.origin.x + rect.size.width*index;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*index, 0, self.frame.size.width, 26)];
        label.tag = i;
        label.text=item;
        [label setBackgroundColor:[UIColor darkGrayColor]];
        //[label setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"textbox.png"]]];
        label.textColor = [UIColor greenColor];
        label.textAlignment = UITextAlignmentCenter;
        //[view addSubview:label];
        [self addSubview:label];
        [label release];
        i+=100;
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = 150;
    int page = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.TransType = [arr objectAtIndex:page];
}
-(NSString*) GetTransType
{
    CGFloat pageWidth = self.frame.size.width;
    int tag = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    UIView *view = [self viewWithTag:(tag+1)*100];
    return ((UILabel*)view).text;
}


@end
