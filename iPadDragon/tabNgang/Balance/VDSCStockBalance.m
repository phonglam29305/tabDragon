//
//  VDSCStockBalance.m
//  iPadDragon
//
//  Created by Lion User on 31/01/2013.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCStockBalance.h"
#import "VDSCStockBalanceCell.h"
#import "VDSCCommonUtils.h"
//#import "GDataXMLNode.h"
#import "VDSCBalanceView.h"

@interface VDSCStockBalance()
{
    VDSCCommonUtils *utils;
    NSMutableArray *WebData_StockBaLance;
    //NSTimer *timer;
    UIWebView *loading;
    VDSCBalanceView *balance;
}
@end
@implementation VDSCStockBalance
//@synthesize imageHeader;
@synthesize tableBalance;
@synthesize lb_TongCongGiaTriThiTruong;
@synthesize lb_tongCongKhaNangNhanNo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//--111111111111111-----------
-(void)awakeFromNib
{
    [super awakeFromNib];
    utils =[[VDSCCommonUtils alloc]init];
    //[self performSelectorInBackground:@selector(initControls) withObject: nil];
    [self initControls];
    balance = (VDSCBalanceView*)self.delegate;
    loading = [utils showLoading:self.tableBalance];
    //timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(sheduleData) userInfo:nil repeats:YES];
    //[timer fire];
}
-(void) sheduleData
{
    [self performSelectorInBackground:@selector(LoadStockBalancce) withObject:nil];
}
//--2222222222
-(void) initControls
{
    // [self.imageHeader setFrame:CGRectMake(0,0, self.frame.size.width, 70)];
    //[self.tableBalance setFrame:CGRectMake(0,55,self.frame.size.width,self.frame.size.height)];
    [self.tableBalance setDelegate:self];
    [self.tableBalance setDataSource:self];
    [self performSelectorInBackground:@selector(LoadStockBalancce) withObject:nil ];
    
}
//--------333333333333333333333----------

-(void) LoadStockBalancce
{
    balance = [(VDSCBalanceView*)self.delegate retain];
    
        self.lb_TongCongGiaTriThiTruong.text=
        [NSString stringWithFormat:@"%@  ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:balance.TongTienGiaTriChungKhoan]]];
        
        self.lb_tongCongKhaNangNhanNo.text=[NSString stringWithFormat:@"%@  ",[utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:balance.TongTienKhaNangNhanNo]]];
        
        
    [self.tableBalance reloadData];
        
    
    
    if(loading !=nil)
    {
        [loading removeFromSuperview];
        [loading release];
        loading=nil;
    }
}

//----4444444444444444444444444------------------------

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return utils.rowHeight;
}
//------------------------------------------------------
//------555555555555555---------------------------------
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{balance = (VDSCBalanceView*)self.delegate;
    if (balance.array_ObjectStockBaklance!=nil && balance.array_ObjectStockBaklance.count>0)
        return balance.array_ObjectStockBaklance.count;
    else
        return  0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"VDSCStockBalanceCell";
    VDSCStockBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifier];
    @try
    {
        balance = (VDSCBalanceView*)self.delegate;
        //------5.11111111111111111
        if(cell == nil)
        {
            cell = [[VDSCStockBalanceCell alloc] init];
        }
        //------5.22222222222222222
        if (balance.array_ObjectStockBaklance != nil && balance.array_ObjectStockBaklance.count>0)
        {
            VDSCObjectStockBalance *obj=[[balance.array_ObjectStockBaklance objectAtIndex:indexPath.row] retain];
            [cell setData2Cell:obj];
        }
        //--------------------------
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
//---66666666---------------------------------------------------

- (void)dealloc {
    //[imageHeader release];
    [tableBalance release];
    [lb_TongCongGiaTriThiTruong release];
    [lb_tongCongKhaNangNhanNo release];
    //[timer invalidate];
    //timer = nil;
    [super dealloc];
}
@end
