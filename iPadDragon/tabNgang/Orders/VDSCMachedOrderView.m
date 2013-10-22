//
//  VDSCMachedOrderView.m
//  iPadDragon
//
//  Created by vdsc on 1/9/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCMachedOrderView.h"
#import "OCCalendarViewController.h"
#import "VDSCCommonUtils.h"
#import "VDSCOrderStatus.h"
#import "VDSCSystemParams.h"
#import "ASIFormDataRequest.h"

@implementation VDSCMachedOrderView
{
    OCCalendarViewController *calVC;
    VDSCCommonUtils *utils;
    NSMutableArray *array;
    NSDate *fdate;
    NSDate *tdate;
    NSOperationQueue *queue;
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
    
    //self.searchBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_searchBar.png"]];
    utils = [[VDSCCommonUtils alloc] init];
    NSDate *startDate = [NSDate date];
    self.txt_fDate.text = [utils.shortDateFormater stringFromDate: startDate];
    self.txt_tDate.text = [utils.shortDateFormater stringFromDate: startDate];
    fdate =
    tdate=[startDate copy];
    
    array = [[NSMutableArray alloc] init];
    self.table_orderList.delegate = self;
    self.table_orderList.dataSource = self;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.table_orderList addGestureRecognizer:gestureRecognizer];
    
}
-(void)hideKeyboard
{
    [self.txt_stock resignFirstResponder];
}
- (void)dealloc {
    [_searchBar release];
    [_txt_tDate release];
    [_txt_fDate release];
    [_table_orderList release];
    [_lbl_ngayGD release];
    [_lbl_phi release];
    [_lbl_thue release];
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
    if(calVC==nil){
        CGPoint insertPoint = ((UIButton*)sender).frame.origin;
        calVC = [[OCCalendarViewController alloc] initAtPoint:insertPoint inView:self arrowPosition:OCArrowPositionCentered selectionMode:OCSelectionSingleDate];
        calVC.delegate = self;
        calVC.sender = sender;
        
        [calVC setStartDate:fdate];
        [calVC setEndDate:fdate];
        
        [self addSubview:calVC.view];
    }
    //[calVC release];
}

-(void)loadData
{
    NSArray *arr;
    @try {
        arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret
               , @"KW_CLIENTID", utils.clientInfo.clientID
               , @"KW_FROMDATE", self.txt_fDate.text
               , @"KW_TODATE", self.txt_tDate.text
               , nil];
        NSString *post = [utils postValueBuilder:arr];
        
        NSString *urlStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"matchedOrderHistory"];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
        request_cash.tag=100;
        
        [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
        [request_cash setRequestMethod:@"POST"];
        [self grabURLInTheBackground:request_cash];
        [arr release];
        
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
}
- (IBAction)grabURLInTheBackground:(ASIFormDataRequest *)request
{
    if (!queue) {
        [queue=[NSOperationQueue alloc] init];
    }
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [queue addOperation:request]; //queue is an NSOperationQueue
}
- (void)requestWentWrong:(ASIFormDataRequest *)request
{
    NSError *error = [request error];
    NSLog(error.description);
}
- (void)requestDone:(ASIFormDataRequest *)request
{
    NSDictionary *allDataDictionary;
    @try{
        NSData *data = [request responseData];
        allDataDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] retain];
        if([allDataDictionary isEqual:[NSNull null]])return;
        if(request.tag==100)
        {
            bool success = [[allDataDictionary objectForKey:@"success"] boolValue];
            if(success)
            {
                [array removeAllObjects];
                if(![[allDataDictionary objectForKey:@"list"] isEqual:[NSNull null]])
                    for(NSArray *arr in [allDataDictionary objectForKey:@"list"])
                    {
                        NSString *stock=[arr objectAtIndex:3] ;
                        NSString *findStock =[self.txt_stock.text uppercaseString];
                        if(findStock ==nil)findStock=@"";
                        if([findStock isEqualToString:@""]||[stock rangeOfString: findStock].location != NSNotFound )
                        {
                            VDSCOrderStatus *item = [[VDSCOrderStatus alloc] init];
                            item.tran_date = [arr objectAtIndex:0];
                            item.settled_date = [arr objectAtIndex:1];
                            item.floor = [arr objectAtIndex:2];
                            item.stock = [arr objectAtIndex:3];
                            item.side = [arr objectAtIndex:4];
                            item.buy_qty = [[arr objectAtIndex:5] doubleValue];
                            item.buy_price = [[arr objectAtIndex:6] doubleValue];
                            item.buy_amount = [[arr objectAtIndex:7] doubleValue];
                            item.sell_qty = [[arr objectAtIndex:8] doubleValue];
                            item.sell_price = [[arr objectAtIndex:9] doubleValue];
                            item.sell_amount = [[arr objectAtIndex:10] doubleValue];
                            item.tax_ratio = [[arr objectAtIndex:11] doubleValue];
                            item.tax_val = [[arr objectAtIndex:12] doubleValue];
                            item.fee_ratio = [[arr objectAtIndex:13] doubleValue];
                            item.fee_val = [[arr objectAtIndex:14] doubleValue];
                            item.settled_amount = [[arr objectAtIndex:15] doubleValue];
                            [array addObject:item];
                        }
                    }
                [self.table_orderList reloadData];
                
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
    @finally {
        if(allDataDictionary!=nil)
            [allDataDictionary release];
        
        
        if(loading !=nil)
        {
            [loading removeFromSuperview];
            [loading release];
            loading = nil;
        }
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
- (IBAction)btn_loadData_touch:(id)sender {
    if(loading==nil && [self checkDate]){
        [self.txt_stock resignFirstResponder];
        loading=[utils showLoading:self.table_orderList];
        [self performSelectorInBackground:@selector(loadData) withObject:nil];
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
        
        [self addSubview:calVC.view];}
    //[calVC release];
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{return 1;}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{return utils.rowHeight;}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"VDSCFullCellPrice";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell==nil){
        cell =[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier] autorelease];
        UIView *bg_view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)]autorelease];
        bg_view.backgroundColor= [UIColor darkGrayColor];
        cell.backgroundView = bg_view;
        //}
        NSInteger i=indexPath.row;
        VDSCOrderStatus *item = [array objectAtIndex:i];
        UIColor *color = [UIColor greenColor];
        if([item.side isEqualToString:@"S"]) color = color = [UIColor colorWithRed:212/255.0 green:10/255.0 blue:201/255.0 alpha:1];//[utils.c_tran retain];
        int x=0;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 130, utils.rowHeight-1);
        label.text = item.settled_date;
        label.backgroundColor = utils.cellBackgroundColor;
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.textColor = color;
        label.textAlignment = UITextAlignmentCenter;
        label.tag=10;
        [label setHidden:self.lbl_ngayGD.tag==0];
        [cell addSubview:label];
        [label release];
        
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 130, utils.rowHeight-1);
        label.text = item.tran_date;
        label.backgroundColor = utils.cellBackgroundColor;
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.textColor = color;
        label.textAlignment = UITextAlignmentCenter;
        [label setHidden:self.lbl_ngayGD.tag==1];
        label.tag=11;
        [cell addSubview:label];
        [label release];
        
        x=label.frame.origin.x+label.frame.size.width+1;
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 79, utils.rowHeight-1);
        label.text = item.stock;
        label.backgroundColor = utils.cellBackgroundColor;
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.textColor = color;
        label.textAlignment = UITextAlignmentCenter;
        label.tag=12;
        [cell addSubview:label];
        [label release];
        
        
        x=label.frame.origin.x+label.frame.size.width+1;
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 66, utils.rowHeight-1);
        if([item.side isEqualToString:@"B"])
            label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:item.buy_qty]]];
        label.backgroundColor = utils.cellBackgroundColor;
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.textAlignment = UITextAlignmentRight;
        label.textColor = color;
        label.tag=13;
        [cell addSubview:label];
        [label release];
        
        x=label.frame.origin.x+label.frame.size.width+1;
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 55, utils.rowHeight-1);
        if([item.side isEqualToString:@"B"])
            label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:item.buy_price]]];
        label.backgroundColor = utils.cellBackgroundColor;
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.textAlignment = UITextAlignmentRight;
        label.textColor = color;
        label.tag=14;
        [cell addSubview:label];
        [label release];
        
        x=label.frame.origin.x+label.frame.size.width+1;
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 95, utils.rowHeight-1);
        if([item.side isEqualToString:@"B"])
            label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.buy_amount]]];
        label.backgroundColor = utils.cellBackgroundColor;
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.textAlignment = UITextAlignmentRight;
        label.textColor = color;
        label.tag=15;
        [cell addSubview:label];
        [label release];
        
        x=label.frame.origin.x+label.frame.size.width+1;
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 66, utils.rowHeight-1);
        if([item.side isEqualToString:@"S"])
            label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:item.sell_qty]]];
        label.backgroundColor = utils.cellBackgroundColor;
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.textAlignment = UITextAlignmentRight;
        label.textColor = color;
        label.tag=16;
        [cell addSubview:label];
        [label release];
        
        x=label.frame.origin.x+label.frame.size.width+1;
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 55, utils.rowHeight-1);
        if([item.side isEqualToString:@"S"])
            label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:item.sell_price]]];
        label.backgroundColor = utils.cellBackgroundColor;
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.textAlignment = UITextAlignmentRight;
        label.textColor = color;
        label.tag=17;
        [cell addSubview:label];
        [label release];
        
        x=label.frame.origin.x+label.frame.size.width+1;
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 95, utils.rowHeight-1);
        if([item.side isEqualToString:@"S"])
            label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.sell_amount]]];
        label.backgroundColor = utils.cellBackgroundColor;
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.textAlignment = UITextAlignmentRight;
        label.textColor = color;
        label.tag=18;
        [cell addSubview:label];
        [label release];
        
        x=label.frame.origin.x+label.frame.size.width+1;
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 74, utils.rowHeight-1);
        label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.fee_ratio]]];
        label.backgroundColor = utils.cellBackgroundColor;
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.textAlignment = UITextAlignmentRight;
        label.textColor = color;
        [label setHidden:self.lbl_phi.tag==0];
        label.tag=20;
        [cell addSubview:label];
        [label release];
        
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 74, utils.rowHeight-1);
        label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.fee_val]]];
        label.backgroundColor = utils.cellBackgroundColor;
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.textAlignment = UITextAlignmentRight;
        label.textColor = color;
        [label setHidden:self.lbl_phi.tag==1];
        label.tag=21;
        [cell addSubview:label];
        [label release];
        
        x=label.frame.origin.x+label.frame.size.width+1;
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 68, utils.rowHeight-1);
        label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.tax_ratio]]];
        label.backgroundColor = utils.cellBackgroundColor;
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.textAlignment = UITextAlignmentRight;
        label.textColor = color;
        [label setHidden:self.lbl_thue.tag==0];
        label.tag=30;
        [cell addSubview:label];
        [label release];
        
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 68, utils.rowHeight-1);
        label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.tax_val]]];
        label.backgroundColor = utils.cellBackgroundColor;
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.textAlignment = UITextAlignmentRight;
        label.textColor = color;
        [label setHidden:self.lbl_thue.tag==1];
        label.tag=31;
        [cell addSubview:label];
        [label release];
        
        x=label.frame.origin.x+label.frame.size.width+1;
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, 187, utils.rowHeight-1);
        label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.settled_amount]]];
        label.backgroundColor = utils.cellBackgroundColor;
        label.font = [UIFont fontWithName:utils.fontFamily size:utils.fontSize];
        label.textAlignment = UITextAlignmentRight;
        label.textColor = color;
        label.tag=19;
        [cell addSubview:label];
        [label release];
    }
    else{
        NSInteger i=indexPath.row;
        VDSCOrderStatus *item = [array objectAtIndex:i];
        UIColor *color = [UIColor greenColor];
        if([item.side isEqualToString:@"S"]) color = color = [UIColor colorWithRed:212/255.0 green:10/255.0 blue:201/255.0 alpha:1];
        UILabel *label = (UILabel*)[cell viewWithTag:10];
        label.text = item.settled_date;
        label.textColor=color;
        [label setHidden:self.lbl_ngayGD.tag==0];
        
        label = (UILabel*)[cell viewWithTag:11];
        label.text = item.tran_date;
        label.textColor=color;
        [label setHidden:self.lbl_ngayGD.tag==1];
        
        
        label = (UILabel*)[cell viewWithTag:12];
        label.text = item.stock;
        label.textColor=color;
        
        
        label = (UILabel*)[cell viewWithTag:13];
        label.text = @"";
        if([item.side isEqualToString:@"B"])
            label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:item.buy_qty]]];
        label.textColor=color;
        
        label = (UILabel*)[cell viewWithTag:14];
        label.text = @"";
        label.textColor=color;
        if([item.side isEqualToString:@"B"])
            label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:item.buy_price]]];
        
        
        label = (UILabel*)[cell viewWithTag:15];
        label.text = @"";
        if([item.side isEqualToString:@"B"])
            label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.buy_amount]]];
        label.textColor = color;
        
        
        label = (UILabel*)[cell viewWithTag:16];
        label.text = @"";
        if([item.side isEqualToString:@"S"])
            label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.sell_qty]]];
        label.textColor = color;
        
        label = (UILabel*)[cell viewWithTag:17];
        label.text = @"";
        label.textColor=color;
        if([item.side isEqualToString:@"S"])
            label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter1Digits stringFromNumber:[NSNumber numberWithDouble:item.sell_price]]];
        
        
        label = (UILabel*)[cell viewWithTag:18];
        label.text = @"";
        if([item.side isEqualToString:@"S"])
            label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.sell_amount]]];
        label.textColor = color;
        
        label = (UILabel*)[cell viewWithTag:19];
        label.textColor=color;
        label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.settled_amount]]];
        
        
        label = (UILabel*)[cell viewWithTag:20];
        label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.fee_ratio]]];
        label.textColor = color;
        [label setHidden:self.lbl_phi.tag==0];
        
        label = (UILabel*)[cell viewWithTag:21];
        label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.fee_val]]];
        label.textColor = color;
        [label setHidden:self.lbl_phi.tag==1];
        
        label = (UILabel*)[cell viewWithTag:30];
        label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.tax_ratio]]];
        label.textColor = color;
        [label setHidden:self.lbl_thue.tag==0];
        
        label = (UILabel*)[cell viewWithTag:31];
        label.text = [NSString stringWithFormat:@"%@", [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:item.tax_val]]];
        [label setHidden:self.lbl_thue.tag==1];
        label.textColor = color;
    }
    return  cell;
    
}

- (IBAction)btn_phi_touch:(id)sender {
    for(VDSCOrderStatus *item in array)
    {
        NSIndexPath *index = [NSIndexPath indexPathForRow:[array indexOfObject:item] inSection:0];
        UITableViewCell *cell = [self.table_orderList cellForRowAtIndexPath:index];
        if(self.lbl_phi.tag==0)
        {
            [[cell viewWithTag:20] setHidden:NO];
            [[cell viewWithTag:21] setHidden:YES];
            
        }
        else
        {
            [[cell viewWithTag:20] setHidden:YES];
            [[cell viewWithTag:21] setHidden:NO];
        }
    }
    if(self.lbl_phi.tag==0)
    {
        self.lbl_phi.tag=1;
    }
    else
    {
        self.lbl_phi.tag=0;
    }
    
}
- (IBAction)btn_ngayGD_touch:(id)sender {
    for(VDSCOrderStatus *item in array)
    {
        NSIndexPath *index = [NSIndexPath indexPathForRow:[array indexOfObject:item] inSection:0];
        UITableViewCell *cell = [self.table_orderList cellForRowAtIndexPath:index];
        if(self.lbl_ngayGD.tag==0)
        {
            [[cell viewWithTag:10] setHidden:NO];
            [[cell viewWithTag:11] setHidden:YES];
            
        }
        else
        {
            [[cell viewWithTag:10] setHidden:YES];
            [[cell viewWithTag:11] setHidden:NO];
        }
    }
    if(self.lbl_ngayGD.tag==0)
    {
        self.lbl_ngayGD.tag=1;
        self.lbl_ngayGD.text=@"Ngày thanh toán";
    }
    else
    {
        self.lbl_ngayGD.tag=0;
        self.lbl_ngayGD.text=@"Ngày giao dịch";
    }
}
- (IBAction)btn_thue_touch:(id)sender {
    for(VDSCOrderStatus *item in array)
    {
        NSIndexPath *index = [NSIndexPath indexPathForRow:[array indexOfObject:item] inSection:0];
        UITableViewCell *cell = [self.table_orderList cellForRowAtIndexPath:index];
        if(self.lbl_thue.tag==0)
        {
            [[cell viewWithTag:30] setHidden:NO];
            [[cell viewWithTag:31] setHidden:YES];
            
        }
        else
        {
            [[cell viewWithTag:30] setHidden:YES];
            [[cell viewWithTag:31] setHidden:NO];
        }
    }
    if(self.lbl_thue.tag==0)
    {
        self.lbl_thue.tag=1;
    }
    else
    {
        self.lbl_thue.tag=0;
    }
}
@end
