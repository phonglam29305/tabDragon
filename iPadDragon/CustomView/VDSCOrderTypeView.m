//
//  VDSCOrderTypeView.m
//  iPadDragon
//
//  Created by vdsc on 1/31/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCOrderTypeView.h"

@interface VDSCOrderTypeView()
{NSArray *arr;}
@end
@implementation VDSCOrderTypeView

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


-(void) initSource: (NSArray*) source
{
    if(source.count==0)return;
    
    self.orderType = [source objectAtIndex:0];
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
        [label setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cbb-loailenh.png"]]];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = UITextAlignmentCenter;
        //[view addSubview:label];
        [self addSubview:label];
        [label release];
        i+=100;
    }
    
}
-(void) initSourceOrderType: (NSMutableArray*) source
{
    if(source.count==0)return;
    
    self.orderType = [source objectAtIndex:0];
    arr = source;
    self.contentSize = CGSizeMake(self.frame.size.width*source.count, self.frame.size.height);
    int i=100;
    [self removeSubviewsOfView];
    for(NSArray *item in source)
    {
        CGRect rect = self.frame;
        int index = [source indexOfObject:item];
        rect.origin.x = rect.origin.x + rect.size.width*index;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*index, 0, self.frame.size.width, 26)];
        label.tag = i;
        label.text=[item objectAtIndex:1];
        [label setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cbb-loailenh.png"]]];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = UITextAlignmentCenter;
        //[view addSubview:label];
        [self addSubview:label];
        [label release];
        i+=100;
    }
    
}
- (void)removeSubviewsOfView
{
    NSArray *subViews = [self subviews];
    for(UIView *view in subViews)
    {
        [view removeFromSuperview];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = 150;
    int page = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.orderType = [arr objectAtIndex:page];
}
-(NSString*) getOrderType
{
    CGFloat pageWidth = self.frame.size.width;
    int tag = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    UIView *view = [self viewWithTag:(tag+1)*100];
    if([view isKindOfClass:[UILabel class]])
        return ((UILabel*)view).text;
    else return @"L";
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
