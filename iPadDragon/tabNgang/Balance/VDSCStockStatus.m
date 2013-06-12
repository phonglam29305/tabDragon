//
//  VDSCStockStatus.m
//  iPadDragon
//
//  Created by Lion User on 02/02/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCStockStatus.h"
#import "VDSCStockStatusCell_.h"
#import "VDSCObjectStockBalance.h"
#import "VDSCCommonUtils.h"
//#import "GDataXMLNode.h"
#import "VDSCBalanceView.h"

@implementation VDSCStockStatus{
    VDSCCommonUtils *utils;
    //NSTimer *timer;
    UIWebView *loading;
    VDSCBalanceView *balance;
}
//@synthesize imageHeader;
@synthesize tableStockStaus;

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
    utils=[[VDSCCommonUtils alloc]init];
    //[self performSelectorInBackground:@selector(initControls) withObject: nil];
    [self initControls];
    loading = [utils showLoading:self.tableStockStaus];
    //timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(sheduleData) userInfo:nil repeats:YES];
    //[timer fire];
}
-(void) sheduleData
{
    [self performSelectorInBackground:@selector(LoadStockStatus) withObject:nil];
}
-(void) initControls
{
    
    // [self.imageHeader setFrame:CGRectMake(0,0,self.frame.size.width,50)];
    //[self.tableStockStaus setFrame:CGRectMake(0,55,self.frame.size.width,self.frame.size.height)];
    [self.tableStockStaus setDelegate:self];
    [self.tableStockStaus setDataSource:self];
    [self performSelectorInBackground:@selector(LoadStockStatus) withObject:nil];
}


//--------333333333333333333333----------


-(void) LoadStockStatus
{
    [self.tableStockStaus reloadData];
    
    if(loading !=nil)
    {
        [loading removeFromSuperview];
        [loading release];
        loading=nil;
    }
    
}
//--------------------------------------------------

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    balance = (VDSCBalanceView*)self.delegate;
    if (balance.array_ObjectStockStatus  !=nil && balance.array_ObjectStockStatus.count>0)
        return balance.array_ObjectStockStatus.count;
    else
        return 0;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{return utils.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"VDSCStockStatusCell_";
    VDSCStockStatusCell_ *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifier];
    
    @try
    {
        balance = (VDSCBalanceView*)self.delegate;
        if(cell == nil)
        {
            cell = [[VDSCStockStatusCell_ alloc] init];
           
        }
        //[cell SetData2Cell:(VDSCObjectStockStatus *)[array_ObjectStockStatus objectAtIndex:indexPath]];
        if (balance.array_ObjectStockStatus  != nil && balance.array_ObjectStockStatus.count>0)
        {
            cell.CellData= [[balance.array_ObjectStockStatus objectAtIndex:indexPath.row] retain];
            [cell SetData2Cell:(VDSCObjectStockBalance *)[balance.array_ObjectStockStatus objectAtIndex:indexPath.row]];
        }
        for(UIView *label in [cell subviews])
        {
            
            if([label isKindOfClass:[UILabel class]])
            {
                [((UILabel*)label)setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
                CGRect rect= ((UILabel*)label).frame;
                rect.size = CGSizeMake(((UILabel*)label).frame.size.width,utils.rowHeight-1);
                ((UILabel*)label).frame=rect;
                ((UILabel*)label).backgroundColor = utils.cellBackgroundColor;
                if([((UILabel*)label).text isEqualToString:@"0  "])
                    ((UILabel*)label).text=@"";
            }
        }
        CGRect rect= cell.frame;
        rect.size.height=utils.rowHeight;
        cell.frame=rect;
        
    }
    @catch (NSException *exception)
    {
        // NSLog([NSString stringWithFormat:@"%@", exception.description]);
    }
    @finally
    {
        //updating = NO;
    }
    return cell;
}
- (void)dealloc {
    // [imageHeader release];
    [tableStockStaus release];
    //[timer invalidate];
    //timer=nil;
    [super dealloc];
}
@end
