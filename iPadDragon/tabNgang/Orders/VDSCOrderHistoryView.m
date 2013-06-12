//
//  VDSCMachedOrderView.m
//  iPadDragon
//
//  Created by vdsc on 1/9/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCOrderHistoryView.h"
#import "VDSCOrderEntity.h"
#import "VDSCCommonUtils.h"
#import "VDSCSystemParams.h"

@implementation VDSCOrderHistoryView
{
    
    OCCalendarViewController *calVC;
    VDSCCommonUtils *utils;
    NSDate *fdate;
    NSDate *tdate;
    NSMutableArray *array_order;
    VDSCSystemParams *params;
    UIWebView *loading;
}

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
    
    utils = [[VDSCCommonUtils alloc] init];
    array_order = [[NSMutableArray alloc] init];
    params = [[VDSCSystemParams alloc] init];
    
    NSDate *startDate = [NSDate date];
    self.txt_fDate.text = [utils.shortDateFormater stringFromDate: startDate];
    self.txt_tDate.text = [utils.shortDateFormater stringFromDate: startDate];
    fdate = tdate=[startDate copy];
    
    
    self.table_todayOderList.delegate = self;
    self.table_todayOderList.dataSource = self;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.table_todayOderList addGestureRecognizer:gestureRecognizer];
    
    //self.searchBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_searchBar.png"]];
}
-(void)hideKeyboard
{
    [self.txt_stock resignFirstResponder];
}
-(void)loadOrders
{
    NSArray *arr;
    NSDictionary *allDataDictionary;
    @try {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@",[user stringForKey:@"orderHistory"]];
        
        arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
               , @"KW_CLIENTID", utils.clientInfo.clientID
               , @"KW_FROMDATE", self.txt_fDate.text
               , @"KW_TODATE", self.txt_tDate.text
               , nil];
        NSString *post = [utils postValueBuilder:arr];
        allDataDictionary = [utils getDataFromUrl:url method:@"POST" postData:post];
        if([[allDataDictionary objectForKey:@"success"] boolValue])
        {
            [array_order removeAllObjects];
            NSArray *data = [allDataDictionary objectForKey:@"list"];
            if( ![[allDataDictionary objectForKey:@"list"] isEqual: [NSNull null]] )
            {
                for (NSArray *arrayOfEntity in data)
                {
                    NSString *stock=[arrayOfEntity objectAtIndex:6] ;
                    if([stock hasPrefix:self.txt_stock.text] || self.txt_stock.text.length==0)
                    {
                        VDSCOrderEntity *price = [[VDSCOrderEntity alloc] init];
                        //price.loadOK = (BOOL *)list obj
                        price.orderId = [arrayOfEntity objectAtIndex:2];
                        //price.orderGroupId = [arrayOfEntity objectForKey:@"groupId"];
                        price.marketId = [arrayOfEntity objectAtIndex:5];
                        price.stockId = [arrayOfEntity objectAtIndex:6];
                        price.side = [arrayOfEntity objectAtIndex:3];
                        price.qty = [[arrayOfEntity objectAtIndex:8] doubleValue];
                        price.price = [[arrayOfEntity objectAtIndex:7] doubleValue];
                        price.wQty = [[arrayOfEntity objectAtIndex:15] doubleValue];
                        price.mQty = [[arrayOfEntity objectAtIndex:10] doubleValue];
                        price.avgMPrice = [[arrayOfEntity objectAtIndex:11] doubleValue];
                        price.status = [params getOrderStatus:[arrayOfEntity objectAtIndex:12] langue:0];
                        price.type = [arrayOfEntity objectAtIndex:4];
                        price.gtd = [arrayOfEntity objectAtIndex:14];
                        price.time = [arrayOfEntity objectAtIndex:0];
                        price.order_chanel = [arrayOfEntity objectAtIndex:13];
                        [array_order addObject:price];
                        [price release];
                    }
                }
            }
            
        }
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
    @finally {
        if(loading !=nil)
        {
            [loading removeFromSuperview];
            [loading release];
            loading = nil;
        }
        
        [self.table_todayOderList reloadData];
        if(arr !=nil)
        [arr release];
        if(allDataDictionary !=nil)
        [allDataDictionary release];
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{return 1;}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{return utils.rowHeight;}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array_order.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"VDSCFullCellPrice";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    UIView *bg_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    bg_view.backgroundColor= [UIColor darkGrayColor];
    cell.backgroundView = bg_view;
    //}
    NSInteger i=indexPath.row;
    VDSCOrderEntity *item = [array_order objectAtIndex:i];
    UIColor *color = [UIColor greenColor];
    if([item.side isEqualToString:@"S"]) color = color = [UIColor colorWithRed:212/255.0 green:10/255.0 blue:201/255.0 alpha:1];//[utils.c_tran retain];
    int x=0;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 97, utils.rowHeight-1);
    label.text = item.time;
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentCenter;
    label.tag=10;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 71, utils.rowHeight-1);
    label.text = [item.side isEqual:@"B"]?@"Mua":@"Bán";
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentCenter;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 49, utils.rowHeight-1);
    label.text = item.marketId;
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentCenter;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 71, utils.rowHeight-1);
    label.text = item.stockId;
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentCenter;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 71, utils.rowHeight-1);
    label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:item.qty]]];
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentRight;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 64, utils.rowHeight-1);
    label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.price]]];
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentRight;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 71, utils.rowHeight-1);
    label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:item.mQty]]];
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentRight;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 64, utils.rowHeight-1);
    label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:item.avgMPrice]]];
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentRight;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 87, utils.rowHeight-1);
    label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:item.wQty]]];
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentRight;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 71, utils.rowHeight-1);
    label.text = [params getOrderType:item.marketId type:item.type];
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentCenter;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 71, utils.rowHeight-1);
    label.text = [params getOrderStatus:item.status langue:0];
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:12];
    label.textColor = color;
    label.textAlignment = UITextAlignmentCenter;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 77, utils.rowHeight-1);
    label.text = item.order_chanel;
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentCenter;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    
    x=label.frame.origin.x+label.frame.size.width+1;
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(x, 0, 104, utils.rowHeight-1);
    label.text = item.gtd;
    label.backgroundColor = utils.cellBackgroundColor;
    label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
    label.textColor = color;
    label.textAlignment = UITextAlignmentCenter;
    label.tag=11;
    [cell addSubview:label];
    [label release];
    
    return cell;
}
- (void)dealloc {
    [_searchBar release];
    [utils release];
    [array_order release];
    [_table_todayOderList release];
    [_txt_fDate release];
    [_txt_tDate release];
    [_txt_stock release];
    [super dealloc];
}
-(void) completedWithNoSelection
{
    [calVC.view removeFromSuperview];
    calVC.delegate = nil;
    [calVC release];
    calVC = nil;
}
-(void)completedWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    if(((UIButton*)calVC.sender).tag==0)
    {
        self.txt_fDate.text = [utils.shortDateFormater stringFromDate: startDate];
        fdate = [startDate copy];
    }
    else
    {
        self.txt_tDate.text = [utils.shortDateFormater stringFromDate: startDate];
        tdate=[startDate copy];
    }
    [calVC.view removeFromSuperview];
    
    calVC.delegate = nil;
    [calVC release];
    calVC = nil;
}
- (IBAction)btn_fDate_touch:(id)sender {
    
    if(calVC ==nil){
        CGPoint insertPoint = ((UIButton*)sender).frame.origin;
        calVC = [[OCCalendarViewController alloc] initAtPoint:insertPoint inView:self arrowPosition:OCArrowPositionCentered selectionMode:OCSelectionSingleDate];
        calVC.delegate = self;
        calVC.sender = sender;
        
        [calVC setStartDate:fdate];
        [calVC setEndDate:fdate];
        
        [self addSubview:calVC.view];
    }
}

- (IBAction)btn_tDate_touch:(id)sender {
    
    if(calVC ==nil){
        CGPoint insertPoint = ((UIButton*)sender).frame.origin;
        calVC = [[OCCalendarViewController alloc] initAtPoint:insertPoint inView:self arrowPosition:OCArrowPositionCentered selectionMode:OCSelectionSingleDate];
        calVC.delegate = self;
        calVC.sender = sender;
        
        [calVC setStartDate:tdate];
        [calVC setEndDate:tdate];
        
        [self addSubview:calVC.view];
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txt_stock resignFirstResponder];
}
-(BOOL) checkDate{
    NSString *start = self.txt_fDate.text;
    NSString *end = self.txt_tDate.text;
    
    
    NSDate *startDate = [utils.shortDateFormater dateFromString:start];
    NSDate *endDate = [utils.shortDateFormater dateFromString:end];
    
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:(NSDayCalendarUnit|NSMonthCalendarUnit)
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    [gregorianCalendar release];
    if(components.month>3 || (components.month==3 && components.day>0))
    {
        [utils showMessage:@"Thời gian tra cứu dữ liệu không được lớn hơn 3 tháng." messageContent:nil];
        return NO;
    }
    return YES;
}
- (IBAction)btn_loadData:(id)sender {
    if(loading==nil && [self checkDate]){
        [self.txt_stock resignFirstResponder];
        loading = [utils showLoading:self.table_todayOderList];
        [self performSelectorInBackground:@selector(loadOrders) withObject:nil];
    }
}
@end
