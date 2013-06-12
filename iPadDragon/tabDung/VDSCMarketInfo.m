//
//  VDSCMarketInfo.m
//  iPadDragon
//
//  Created by vdsc on 12/24/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import "VDSCMarketInfo.h"
#import "VDSCMarketIndex.h"
#import "VDSCFullCellPrice.h"
#import "VDSCIndexEntity.h"
#import "VDSCPriceBoardEntity.h"
#import "VDSCFullPriceBoard_PopoverViewController.h"
#import "VDSCChangeStockEntity.h"
#import "VDSCPriceListViewController.h"
#import "ASIFormDataRequest.h"

@interface VDSCMarketInfo()
{
    NSMutableArray *array_price_change;
    NSMutableData *webData_price;
    NSURLConnection *connection_price;
    
    long nextVersion;
    VDSCCommonUtils *utils;
    bool updating;
    bool loadFull;
    VDSCMarketIndexView *marketIndexView ;
    NSOperationQueue *queue;
    UIWebView *loading;
    
}

@end
@implementation VDSCMarketInfo
@synthesize allDataDictionary;
@synthesize data_tmp;
@synthesize priceBoard;
@synthesize popover;
@synthesize root_array_price;
@synthesize array_price_change;
@synthesize array_price;
@synthesize miniPriceBoard;
@synthesize timer_price;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self setNeedsDisplay];
}
-(void) awakeFromNib
{
    [super awakeFromNib];
    self.bar_search.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_searchBar.png"]];
    [priceBoard setDelegate:self];
    [priceBoard setDataSource:self];
    
    self.f_keyWord.delegate=self;
    nextVersion=0;
    array_price = [[NSMutableArray alloc] init];
    root_array_price = [[NSMutableArray alloc] init];
    array_price_change = [[NSMutableArray alloc] init];
    utils =[[VDSCCommonUtils alloc] init];
    loadFull = YES;
    
    timer_price= [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(loadPriceBoard) userInfo:nil repeats:YES];
    [timer_price fire];
    //[self loadPriceBoard];
    //[self performSelectorInBackground:@selector(loadPriceBoard) withObject:nil];
    [self.f_keyWord addTarget:self action:@selector(f_keyWordValueChanged:) forControlEvents:UIControlEventEditingChanged];
    updating = NO;
    allDataDictionary = [[NSMutableDictionary alloc] init];
    
    data_tmp = [[NSMutableArray alloc] init];
    
    
    marketIndexView = [[[NSBundle mainBundle] loadNibNamed:@"VDSCMarketIndexView" owner:self options:nil] objectAtIndex:0];
    marketIndexView.delegate = self;
    [self.marketIndex addSubview:marketIndexView];
    [marketIndexView release];
}

- (IBAction)f_keyWordValueChanged:(id)sender {
    //if(miniPriceBoard.tag == 0){
        UITextField *textField = (UITextField*) sender;
        
        
        NSString *keyWord = [textField.text uppercaseString];
        if([keyWord isEqualToString:@""]||[keyWord isEqualToString:@"0 objects"]){
            array_price = [root_array_price retain];
        }
        else if (root_array_price!=nil && root_array_price.count>0) {
            NSMutableArray *newarray = [[NSMutableArray alloc] init];
            for(VDSCPriceBoardEntity *data in root_array_price)
            {
                NSString *maCK = [NSString stringWithFormat:@"%@", [data.f_ma objectAtIndex:0]];
                if ([maCK hasPrefix:keyWord]) {
                    [newarray addObject: data];
                }
            }
            array_price = newarray;
        }
        [priceBoard reloadData];
    //}
    //else
    //{
        //UITextField *textField = (UITextField*) sender;
        
        
        //NSString *keyWord = [textField.text uppercaseString];
        if([keyWord isEqualToString:@""]||[keyWord isEqualToString:@"0 objects"]){
            miniPriceBoard.array_price = [root_array_price retain];
        }
        else if (root_array_price!=nil && root_array_price.count>0) {
            NSMutableArray *newarray = [[NSMutableArray alloc] init];
            for(VDSCPriceBoardEntity *data in root_array_price)
            {
                NSString *maCK = [NSString stringWithFormat:@"%@", [data.f_ma objectAtIndex:0]];
                if ([maCK hasPrefix:keyWord]) {
                    [newarray addObject: data];
                }
            }
            miniPriceBoard.array_price = [newarray retain];
            [newarray release];
        }
        [miniPriceBoard.priceBoard reloadData];
    //}
}

- (IBAction)btn_San_Touch:(id)sender {
    
    [self.f_keyWord resignFirstResponder];
    VDSCPriceListViewController *popover_Vew = [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"VDSCPriceListView"];
    popover = [[UIPopoverController alloc] initWithContentViewController:popover_Vew];
    CGRect rect = CGRectMake(-120, -130, 200,300);
    popover_Vew.marketInfo = self;
    popover.delegate = self;
    popover_Vew.type_1list_2category=1;
    [popover presentPopoverFromRect:rect  inView:self.bar_search permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    //[popover_Vew release];
}

-(void) dismissPopoverController:(UIPopoverController *)popover
{
    if(popover!=nil)
    {
        //[popover.contentViewController release];
        [popover dismissPopoverAnimated:YES];
        [popover release];
        popover = nil;
    }
    loadFull=YES;
    [root_array_price removeAllObjects];
    if(miniPriceBoard!=nil){miniPriceBoard.loadFull = YES;}
    updating=NO;
    self.f_keyWord.text=@"";
    //nextVersion=0;
    //if(timer_price !=nil){[timer_price invalidate];timer_price = nil;}
    //[self performSelectorInBackground:@selector(loadPriceBoard) withObject:nil];
}

- (IBAction)btn_Nganh_Touch:(id)sender {
    [self.f_keyWord resignFirstResponder];
    VDSCPriceListViewController *popover_Vew = [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"VDSCPriceListView"];
    popover_Vew.marketInfo = self;
    popover_Vew.type_1list_2category=2;
    popover = [[UIPopoverController alloc] initWithContentViewController:popover_Vew];
    CGRect rect = CGRectMake(30, -130, 200,300);
    [popover presentPopoverFromRect:rect  inView:self.bar_search permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)showMiniPriceBoard:(id)sender {
    
    [self.f_keyWord resignFirstResponder];
    if(miniPriceBoard==nil){
        miniPriceBoard = [[[NSBundle mainBundle] loadNibNamed:@"VDSCMiniPriceBoard" owner:self options:nil] objectAtIndex:0];
        miniPriceBoard.frame = CGRectMake(0, 98, self.superview.frame.size.width, 550);
        miniPriceBoard.delegate = self;
        miniPriceBoard.tag=0;
        [miniPriceBoard loadPriceBoard];
        [self.superview addSubview:miniPriceBoard];
    }
    if(self.btn_showMiniPriceBoard.tag==0)
    {
        self.btn_showMiniPriceBoard.tag=1;
        miniPriceBoard.tag=1;
        [self.superview bringSubviewToFront:miniPriceBoard];
        [((UIButton*)sender) setBackgroundImage:[UIImage imageNamed:@"bg_searchBar_swtich.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.btn_showMiniPriceBoard.tag=0;
        miniPriceBoard.tag=0;
        [self.superview sendSubviewToBack:miniPriceBoard];
        [((UIButton*)sender) setBackgroundImage:[UIImage imageNamed:@"btn-banggia-mini.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)btn_add_touch:(id)sender {
    
    NSString *floor=[((VDSCMainViewController*)self.delegate) getMarketByStock:self.f_keyWord.text];
    if([floor isEqualToString:@""])
    {
        [utils showMessage:
         [utils.dic_language objectForKey:@"ipad.watchingList.worngStock"] messageContent:nil dismissAfter:2];
        return;
    }
    if([((VDSCMainViewController*)self.delegate) checkStockInWatchingList:self.f_keyWord.text])
    {
        //[utils showMessage:[utils.dic_language objectForKey:@"ipad.watchingList.existsStock"] messageContent:nil dismissAfter:2];
        //return;
        [utils removeStock2WatchingList:self.f_keyWord.text marketId:floor];
        [((VDSCMainViewController*)self.delegate) addRemoveStockInWatchingList:NO stockId:self.f_keyWord.text  marketId:floor];
    }
    else{
    [
        utils addStock2WatchingList:self.f_keyWord.text marketId:floor];
        [((VDSCMainViewController*)self.delegate) addRemoveStockInWatchingList:YES stockId:self.f_keyWord.text  marketId:floor];
    }
    self.f_keyWord.text=@"";
    [self.f_keyWord resignFirstResponder];
    [self f_keyWordValueChanged:self.f_keyWord];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //if(textField == self.fieldMaTK)
    //    [self.fieldMatKhau becomeFirstResponder];
    //else
        [self btn_add_touch:nil];
    return YES;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData_price setLength:0];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Fail:********************");
    updating=NO;
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData_price  appendData:data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    @try {
        
        
        if(loadFull)
        {
            if(webData_price == nil){
                updating=NO;
                [root_array_price removeAllObjects];
                [array_price removeAllObjects];
                [priceBoard reloadData];
                if(miniPriceBoard!=nil)
                {
                    [miniPriceBoard.root_array_price removeAllObjects];
                    [miniPriceBoard.array_price removeAllObjects];
                    [miniPriceBoard.priceBoard reloadData];
                }
                return;
            }
            self.allDataDictionary = [[NSJSONSerialization JSONObjectWithData:webData_price options:0 error:nil] retain];
            NSArray *data = [[self.allDataDictionary objectForKey:@"list"] retain];
            if(data ==nil || [[self.allDataDictionary objectForKey:@"list"] isEqual:[NSNull null]]){
                updating=NO;
                [root_array_price removeAllObjects];
                [array_price removeAllObjects];
                [priceBoard reloadData];
                if(miniPriceBoard!=nil)
                {
                    [miniPriceBoard.root_array_price removeAllObjects];
                    [miniPriceBoard.array_price removeAllObjects];
                    [miniPriceBoard.priceBoard reloadData];
                }
                return;
            }
            
            id obj = [self.allDataDictionary objectForKey:@"version"];
            nextVersion = [obj longValue];
            
            for (NSArray *arrayOfEntity in data)
            {
                
                NSString *floor = [self.lbl_San.text lowercaseString];
                if([floor isEqualToString: @"hose"])
                    floor = @"hsx";
                if([floor isEqualToString: @"vn30"])
                    floor = @"hsx";
                if([floor isEqualToString: @"hnx30"])
                    floor = @"hnx";
                VDSCPriceBoardEntity *price = [[VDSCPriceBoardEntity alloc] init];
                //price.loadOK = (BOOL *)list obj
                price.f_ma = [arrayOfEntity objectAtIndex:0];
                price.f_maCK = [price.f_ma objectAtIndex:0];
                price.f_sanGD = floor;
                price.f_tran = [arrayOfEntity objectAtIndex:2];
                price.f_san = [arrayOfEntity objectAtIndex:3];
                price.f_thamchieu = [arrayOfEntity objectAtIndex:1];
                
                price.f_mua3_gia = [arrayOfEntity objectAtIndex:5];
                price.f_mua3_kl = [arrayOfEntity objectAtIndex:6];
                price.f_mua2_gia = [arrayOfEntity objectAtIndex:7];
                price.f_mua2_kl = [arrayOfEntity objectAtIndex:8];
                price.f_mua1_gia = [arrayOfEntity objectAtIndex:9];
                price.f_mua1_kl = [arrayOfEntity objectAtIndex:10];
                
                price.f_kl_gia = [arrayOfEntity objectAtIndex:11];
                price.f_kl_kl = [arrayOfEntity objectAtIndex:12];
                price.f_kl_tangGiam = [arrayOfEntity objectAtIndex:13];
                price.f_kl_tongkl = [arrayOfEntity objectAtIndex:14];
                
                price.f_ban1_gia = [arrayOfEntity objectAtIndex:15];
                price.f_ban1_kl = [arrayOfEntity objectAtIndex:16];
                price.f_ban2_gia = [arrayOfEntity objectAtIndex:17];
                price.f_ban2_kl = [arrayOfEntity objectAtIndex:18];
                price.f_ban3_gia = [arrayOfEntity objectAtIndex:19];
                price.f_ban3_kl = [arrayOfEntity objectAtIndex:20];
                
                price.f_moCua = [arrayOfEntity objectAtIndex:22];
                price.f_cao = [arrayOfEntity objectAtIndex:23];
                price.f_thap = [arrayOfEntity objectAtIndex:24];
                price.f_trungBinh = [arrayOfEntity objectAtIndex:25];
                
                price.f_nuocNgoai_mua = [arrayOfEntity objectAtIndex:26];
                price.f_nuocNgoai_ban = [arrayOfEntity objectAtIndex:27];
                [root_array_price addObject:price];
                
                [price release];
            }
            
            array_price = [root_array_price retain];
            [priceBoard reloadData];
            loadFull = NO;
            //[webData_price release];
            [allDataDictionary release];
        }
        else{
            if(webData_price ==nil){updating=NO;return;}
            [array_price_change removeAllObjects];
            //NSString *json = [[NSString alloc] initWithBytes:[webData_price mutableBytes] length:[webData_price length] encoding:NSUTF8StringEncoding];
            //NSLog(json);
            self.allDataDictionary = [[NSJSONSerialization JSONObjectWithData:webData_price options:0 error:nil] retain];
            self.data_tmp = [[self.allDataDictionary objectForKey:@"list"] retain];
            if([[self.allDataDictionary objectForKey:@"list"] isEqual:[NSNull null]]){updating=NO;return;}
            if(data_tmp!=nil && ![data_tmp isKindOfClass:[NSNull class]]&& data_tmp.count>0)
            {
                for (NSArray *arrayOfEntity in data_tmp) {
                    VDSCChangeStockEntity *entity = [VDSCChangeStockEntity alloc];
                    entity.code = [arrayOfEntity objectAtIndex:0];
                    entity.value = [arrayOfEntity objectAtIndex:1];
                    entity.color = [arrayOfEntity objectAtIndex:2];
                    [array_price_change addObject:entity];
                    [entity release];
                }
                
            }
            
            id obj = [self.allDataDictionary objectForKey:@"responseVersion"];
            nextVersion = [obj longValue];
            obj = [self.allDataDictionary objectForKey:@"success"];
            if([obj boolValue] == YES && array_price_change.count>0 && nextVersion>0)
            {
                [self compareAndHighLightCell];
                
                //[self performSelectorInBackground:@selector(compareAndHighLightCell) withObject:nil];
            }
            //NSLog([NSString stringWithFormat:@"Client:%ld",nextVersion]);
            id serverVersion = [self.allDataDictionary objectForKey:@"serverVersion"];
            //NSLog([NSString stringWithFormat:@"Server:%ld",[serverVersion longValue]]);
            if([self.lbl_San.text isEqualToString:@"Danh mục quan tâm"])
            {
                //if(nextVersion > [serverVersion longValue])
                nextVersion=[serverVersion longValue]-1;
            }
            obj = [self.allDataDictionary objectForKey:@"isReload"];
            loadFull = [obj boolValue];
            
            if([obj boolValue]==NO)
            {
                if([serverVersion longValue] - nextVersion>50)
                    loadFull = YES;
            }
            
            [data_tmp release];
            [allDataDictionary release];
            //[webData_price release];
        }
        //updating=NO;
        
    }
    @catch (NSException *exception) {
        NSLog([NSString stringWithFormat:@"connectionDidFinishLoading: %@, %@", exception.description, exception.debugDescription]);
        //updating=NO;
    }
    @finally {
        updating=NO;
        if(loading!=nil)
        {
            [loading removeFromSuperview];
            [loading release];
            loading=nil;
        }
    }
}
-(void) compareAndHighLightCell
{
    int i=0;
    int j=0;
    @try {
        
        if(array_price !=nil && array_price.count>0 && array_price_change!=nil && array_price_change.count>0)
        {
            updating=YES;
            
            for(VDSCPriceBoardEntity *data in array_price)
            {
                int index = [array_price indexOfObject:data];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                VDSCFullCellPrice *cell = [(VDSCFullCellPrice *)[priceBoard cellForRowAtIndexPath:indexPath] retain];
                
                if(cell != nil)
                {
                    NSString *maCK = cell.f_ma.text;
                    //NSLog([NSString stringWithFormat:@"mack:%@",maCK]);
                    for(VDSCChangeStockEntity *new_data in array_price_change)
                    {
                        NSString *maCK_new = [NSString stringWithFormat:@"%@", new_data.code];
                        NSString *code = [maCK_new stringByReplacingOccurrencesOfString:maCK withString:@""];
                        
                        //NSLog([NSString stringWithFormat:@"cell:%@",maCK]);
                        if( [code rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound)
                        {
                            //NSLog([NSString stringWithFormat:@"cell:%@",code]);
                            UIView *control = [cell viewWithTag:[code integerValue]-1];
                            if([code integerValue]==0)
                                control = [cell viewWithTag:100];
                            if([code integerValue]<21)
                                i+=1;
                            if(control != Nil)
                            {
                                //NSLog([NSString stringWithFormat:@"mack-new:%@",maCK_new]);
                                UILabel *label = (UILabel*)control;
                                j +=1;
                                if( [(NSString *)new_data.value rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound)
                                {
                                    double d = [(NSString *)new_data.value doubleValue]/10;
                                    label.text =[NSString stringWithFormat:@"%@",[utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
                                }
                                else {
                                    
                                    label.text = (NSString *)new_data.value;
                                }
                                [utils setLabelColor:new_data.color label:label];
                                //label.backgroundColor = [UIColor grayColor];
                                
                                UILabel *label_tem = [[UILabel alloc]initWithFrame:label.frame];
                                label_tem.font = label.font;
                                label_tem.textAlignment = label.textAlignment;
                                label_tem.textColor=label.textColor;
                                label_tem.text = label.text;
                                label_tem.backgroundColor = [UIColor grayColor];
                                [cell addSubview:label_tem];
                                [self performSelectorInBackground:@selector(highlightLabel:) withObject:label_tem];
                            }
                        }
                        // }
                    }
                }
                //[cell release];
            }
            //}
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog([NSString stringWithFormat:@"compareAndHighLightCell: %@, %@", exception.description, exception.debugDescription]);
        
    }
    @finally {
        updating=NO;
    }
}

-(void) highlightLabel:(UILabel *) label
{
    sleep(1);
    [label removeFromSuperview];
    [label release];
}


-(void) loadPriceBoard
{
    
    
    NSLog([NSString stringWithFormat: @"begin loading: %@", [NSDate date]] );
    NSString *floor = [self.lbl_San.text lowercaseString];
    if([floor isEqualToString: @"hose"])
        floor = @"hsx";
    if([floor isEqualToString: @"vn30"])
        floor = @"mix_vn30";
    if([floor isEqualToString: @"hnx30"])
        floor = @"mix_hnx30";
    if([floor isEqualToString: @"danh mục quan tâm"])
        floor = @"all";
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:[user stringForKey:@"root_priceBoard"], floor, self.lbl_Nganh.tag]];
    if([floor isEqualToString: @"all"] && loadFull)
    {
        [self loadWatchingStocks];
    }
    else
    {
        if(!loadFull)
        {
            if([floor isEqualToString: @"mix_vn30"])
                floor = @"hsx";
            if([floor isEqualToString: @"mix_hnx30"])
                floor = @"hnx";
            url = [NSURL URLWithString:[NSString stringWithFormat:[user stringForKey:@"change_priceBoard"], floor, nextVersion]];
        }
        //else loading = [utils showLoading:priceBoard];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        if (connection_price ==nil && updating == NO ) {
            connection_price = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            updating=YES;
            if(connection_price)
            {
                webData_price = [[NSMutableData alloc] init];
            }
        }
        [request release];
        [connection_price release];
         connection_price = nil;
        /*ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url];
        request_cash.tag=100;
        updating=YES;
        
        [request_cash setRequestMethod:@"GET"];
        [self grabURLInTheBackground:request_cash];*/
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

- (void)requestDone:(ASIFormDataRequest *)request
{
    @try {
        
        
        if(loadFull)
        {
            if(request.responseData.length == 0){
                updating=NO;
                [root_array_price removeAllObjects];
                [array_price removeAllObjects];
                [priceBoard reloadData];
                if(miniPriceBoard!=nil)
                {
                    [miniPriceBoard.root_array_price removeAllObjects];
                    [miniPriceBoard.array_price removeAllObjects];
                    [miniPriceBoard.priceBoard reloadData];
                }
                return;
            }
            self.allDataDictionary = [[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil] retain];
            NSArray *data = [[self.allDataDictionary objectForKey:@"list"] retain];
            if(data ==nil || [[self.allDataDictionary objectForKey:@"list"] isEqual:[NSNull null]]){
                updating=NO;
                [root_array_price removeAllObjects];
                [array_price removeAllObjects];
                [priceBoard reloadData];
                if(miniPriceBoard!=nil)
                {
                    [miniPriceBoard.root_array_price removeAllObjects];
                    [miniPriceBoard.array_price removeAllObjects];
                    [miniPriceBoard.priceBoard reloadData];
                }
                return;
            }
            
            id obj = [self.allDataDictionary objectForKey:@"version"];
            nextVersion = [obj longValue];
            
            for (NSArray *arrayOfEntity in data)
            {
                
                NSString *floor = [self.lbl_San.text lowercaseString];
                if([floor isEqualToString: @"hose"])
                    floor = @"hsx";
                if([floor isEqualToString: @"vn30"])
                    floor = @"hsx";
                if([floor isEqualToString: @"hnx30"])
                    floor = @"hnx";
                VDSCPriceBoardEntity *price = [[VDSCPriceBoardEntity alloc] init];
                //price.loadOK = (BOOL *)list obj
                price.f_ma = [arrayOfEntity objectAtIndex:0];
                price.f_maCK = [price.f_ma objectAtIndex:0];
                price.f_sanGD = floor;
                price.f_tran = [arrayOfEntity objectAtIndex:2];
                price.f_san = [arrayOfEntity objectAtIndex:3];
                price.f_thamchieu = [arrayOfEntity objectAtIndex:1];
                
                price.f_mua3_gia = [arrayOfEntity objectAtIndex:5];
                price.f_mua3_kl = [arrayOfEntity objectAtIndex:6];
                price.f_mua2_gia = [arrayOfEntity objectAtIndex:7];
                price.f_mua2_kl = [arrayOfEntity objectAtIndex:8];
                price.f_mua1_gia = [arrayOfEntity objectAtIndex:9];
                price.f_mua1_kl = [arrayOfEntity objectAtIndex:10];
                
                price.f_kl_gia = [arrayOfEntity objectAtIndex:11];
                price.f_kl_kl = [arrayOfEntity objectAtIndex:12];
                price.f_kl_tangGiam = [arrayOfEntity objectAtIndex:13];
                price.f_kl_tongkl = [arrayOfEntity objectAtIndex:14];
                
                price.f_ban1_gia = [arrayOfEntity objectAtIndex:15];
                price.f_ban1_kl = [arrayOfEntity objectAtIndex:16];
                price.f_ban2_gia = [arrayOfEntity objectAtIndex:17];
                price.f_ban2_kl = [arrayOfEntity objectAtIndex:18];
                price.f_ban3_gia = [arrayOfEntity objectAtIndex:19];
                price.f_ban3_kl = [arrayOfEntity objectAtIndex:20];
                
                price.f_moCua = [arrayOfEntity objectAtIndex:22];
                price.f_cao = [arrayOfEntity objectAtIndex:23];
                price.f_thap = [arrayOfEntity objectAtIndex:24];
                price.f_trungBinh = [arrayOfEntity objectAtIndex:25];
                
                price.f_nuocNgoai_mua = [arrayOfEntity objectAtIndex:26];
                price.f_nuocNgoai_ban = [arrayOfEntity objectAtIndex:27];
                [root_array_price addObject:price];
                
                [price release];
            }
            
            array_price = [root_array_price retain];
            [priceBoard reloadData];
            loadFull = NO;
            //[webData_price release];
            [allDataDictionary release];
        }
        else{
            if(request.responseData.length ==0){updating=NO;return;}
            [array_price_change removeAllObjects];
            //NSString *json = [[NSString alloc] initWithBytes:[webData_price mutableBytes] length:[webData_price length] encoding:NSUTF8StringEncoding];
            //NSLog(json);
            self.allDataDictionary = [[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil] retain];
            self.data_tmp = [[self.allDataDictionary objectForKey:@"list"] retain];
            if([[self.allDataDictionary objectForKey:@"list"] isEqual:[NSNull null]]){updating=NO;return;}
            if(data_tmp!=nil && ![data_tmp isKindOfClass:[NSNull class]]&& data_tmp.count>0)
            {
                for (NSArray *arrayOfEntity in data_tmp) {
                    VDSCChangeStockEntity *entity = [VDSCChangeStockEntity alloc];
                    entity.code = [arrayOfEntity objectAtIndex:0];
                    entity.value = [arrayOfEntity objectAtIndex:1];
                    entity.color = [arrayOfEntity objectAtIndex:2];
                    [array_price_change addObject:entity];
                    [entity release];
                }
                
            }
            
            id obj = [self.allDataDictionary objectForKey:@"responseVersion"];
            nextVersion = [obj longValue];
            obj = [self.allDataDictionary objectForKey:@"success"];
            if([obj boolValue] == YES && array_price_change.count>0 && nextVersion>0)
            {
                [self compareAndHighLightCell];
                
                //[self performSelectorInBackground:@selector(compareAndHighLightCell) withObject:nil];
            }
            //NSLog([NSString stringWithFormat:@"Client:%ld",nextVersion]);
            id serverVersion = [self.allDataDictionary objectForKey:@"serverVersion"];
            //NSLog([NSString stringWithFormat:@"Server:%ld",[serverVersion longValue]]);
            if([self.lbl_San.text isEqualToString:@"Danh mục quan tâm"])
            {
                //if(nextVersion > [serverVersion longValue])
                nextVersion=[serverVersion longValue]-1;
            }
            obj = [self.allDataDictionary objectForKey:@"isReload"];
            loadFull = [obj boolValue];
            
            if([obj boolValue]==NO)
            {
                if([serverVersion longValue] - nextVersion>50)
                    loadFull = YES;
            }
            
            [data_tmp release];
            [allDataDictionary release];
            //[webData_price release];
        }
        //updating=NO;
        
    }
    @catch (NSException *exception) {
        NSLog([NSString stringWithFormat:@"connectionDidFinishLoading: %@, %@", exception.description, exception.debugDescription]);
        //updating=NO;
    }
    @finally {
        updating=NO;
        if(loading!=nil)
        {
            [loading removeFromSuperview];
            [loading release];
            loading=nil;
        }
    }
}
- (void)requestWentWrong:(ASIFormDataRequest *)request
{
    NSError *error = [request error];
    NSLog(error.description);
    if(loading!=nil){
        [loading removeFromSuperview];
        [loading release];
        loading=nil;
    }
    updating=NO;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.f_keyWord resignFirstResponder];
}
-(void) loadWatchingStocks
{
    @try{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    //if(((VDSCMainViewController*)self.delegate).array_watchList==nil){
        NSArray *arr = [[NSArray alloc] initWithObjects:@"KW_CLIENTSECRET",utils.clientInfo.secret, @"KW_CLIENTID", utils.clientInfo.clientID, nil];
        NSString *post = [utils postValueBuilder:arr];
        
        NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"getWatchingStocks"];
        NSDictionary *allDataDic = [utils getDataFromUrl:url method:@"POST" postData:post];
        if([[allDataDic objectForKey:@"success"] boolValue])
        {
            [list removeAllObjects];
            
            if([[allDataDic objectForKey:@"list"] isEqual:[NSNull null]])
            {
                [root_array_price removeAllObjects];
                [array_price removeAllObjects];
                [priceBoard reloadData];
                return;
            }
            for(NSArray *item in [allDataDic objectForKey:@"list"])
            {
                [list addObject:item];
            }
            [allDataDic release];
            
            //NSLog([NSString stringWithFormat:@"end: %@", [utils.longDateFormater stringFromDate: [NSDate date]]]);
        }
    //}
    //else list = [((VDSCMainViewController*)self.delegate).array_watchList retain];
    if(list.count>0)
    {
        [self.root_array_price removeAllObjects];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        for(NSArray *item in list)
        {
            NSString *stock=[item objectAtIndex:0];
            NSString *url= [NSString stringWithFormat:[user stringForKey:@"stock_info"], stock];
            
            NSDictionary *allDataDictionary_stock = [utils getDataFromUrl:url method:@"GET" postData:nil];
            
            NSArray *arrayOfEntity = [allDataDictionary_stock objectForKey:@"stock"];
            
            VDSCPriceBoardEntity *stockEntity = [[VDSCPriceBoardEntity alloc] init];
            stockEntity.f_tenCty = [allDataDictionary_stock objectForKey:@"name"];
            stockEntity.f_sanGD = [item objectAtIndex:1];
            stockEntity.f_maCK = [item objectAtIndex:0];
            stockEntity.f_ma = [arrayOfEntity objectAtIndex:0];
            stockEntity.f_tran = [arrayOfEntity objectAtIndex:2];
            stockEntity.f_san = [arrayOfEntity objectAtIndex:3];
            stockEntity.f_thamchieu = [arrayOfEntity objectAtIndex:1];
            
            stockEntity.f_mua4_kl = [arrayOfEntity objectAtIndex:4];
            stockEntity.f_mua3_gia = [arrayOfEntity objectAtIndex:5];
            stockEntity.f_mua3_kl = [arrayOfEntity objectAtIndex:6];
            stockEntity.f_mua2_gia = [arrayOfEntity objectAtIndex:7];
            stockEntity.f_mua2_kl = [arrayOfEntity objectAtIndex:8];
            stockEntity.f_mua1_gia = [arrayOfEntity objectAtIndex:9];
            stockEntity.f_mua1_kl = [arrayOfEntity objectAtIndex:10];
            
            stockEntity.f_kl_gia = [arrayOfEntity objectAtIndex:11];
            stockEntity.f_kl_kl = [arrayOfEntity objectAtIndex:12];
            stockEntity.f_kl_tangGiam = [arrayOfEntity objectAtIndex:13];
            stockEntity.f_kl_tongkl = [arrayOfEntity objectAtIndex:14];
            
            stockEntity.f_ban1_gia = [arrayOfEntity objectAtIndex:15];
            stockEntity.f_ban1_kl = [arrayOfEntity objectAtIndex:16];
            stockEntity.f_ban2_gia = [arrayOfEntity objectAtIndex:17];
            stockEntity.f_ban2_kl = [arrayOfEntity objectAtIndex:18];
            stockEntity.f_ban3_gia = [arrayOfEntity objectAtIndex:19];
            stockEntity.f_ban3_kl = [arrayOfEntity objectAtIndex:20];
            stockEntity.f_ban4_kl = [arrayOfEntity objectAtIndex:21];
            
            stockEntity.f_moCua = [arrayOfEntity objectAtIndex:22];
            stockEntity.f_cao = [arrayOfEntity objectAtIndex:23];
            stockEntity.f_thap = [arrayOfEntity objectAtIndex:24];
            stockEntity.f_trungBinh = [arrayOfEntity objectAtIndex:25];
            stockEntity.f_nuocNgoai_mua = [arrayOfEntity objectAtIndex:26];
            stockEntity.f_nuocNgoai_ban = [arrayOfEntity objectAtIndex:27];
            [root_array_price addObject:stockEntity];
            [stockEntity release];
            
            stockEntity = nil;
        }
        
        array_price = root_array_price;
        [priceBoard reloadData];
        loadFull = NO;
        [list release];
    }
    else{
        [root_array_price removeAllObjects];
        [priceBoard reloadData];
        if(miniPriceBoard!=nil)
        {
            [miniPriceBoard.root_array_price removeAllObjects];
            [miniPriceBoard.priceBoard reloadData];
        }
    }
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{return 1;}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (array_price!=nil && array_price.count>0)
        return array_price.count;
    else return  0;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(array_price!=nil && array_price.count>0){
        [self.f_keyWord resignFirstResponder];
        VDSCFullPriceBoard_PopoverViewController *popover_Vew = [[self.superview.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:@"FullPriceBoard_Popover"];
        VDSCFullCellPrice *cell = (VDSCFullCellPrice *)[tableView cellForRowAtIndexPath:indexPath];
        popover = [[UIPopoverController alloc] initWithContentViewController:popover_Vew];
        popover.delegate = self;
        popover_Vew.delegate = self.delegate;
        CGRect rect=CGRectMake(cell.bounds.origin.x+500, cell.bounds.origin.y+5, 50, 30);
        popover_Vew.priceEntity = [array_price objectAtIndex:indexPath.row];
        [popover_Vew assignDataToControl];
        popover_Vew.marketInfo = self;
        popover_Vew.currentCell = [cell retain];
        [popover presentPopoverFromRect:rect inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIndentifier_1 = @"VDSCFullCellPrice_1";
    NSString *cellIndentifier_2 = @"VDSCFullCellPrice_2";
    VDSCFullCellPrice *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifier_1];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifier_1];
    @try {
        if(cell == nil)
        {
            //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier_1];
            
            cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifier_2];
            if(cell == nil)
            {
                if(indexPath.row%2==0)
                {
                    cell = [[VDSCFullCellPrice alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier_1];
                }
                else
                {
                    cell = [[VDSCFullCellPrice alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier_2];
                }
            }
        }
        if (array_price != nil && array_price.count>0)
        {
            //VDSCPriceBoardEntity *entity=[array_price objectAtIndex:indexPath.row];
            //cell.textLabel.text = [entity.f_ma objectAtIndex:0];
            cell.cellData = [array_price objectAtIndex:indexPath.row];
            [cell setCellValue:[array_price objectAtIndex:indexPath.row]];
        }
        for(UIView *label in [cell subviews])
        {
            
            if([label isKindOfClass:[UILabel class]])
            {
                [((UILabel*)label)setFont:[UIFont fontWithName:utils.fontFamily size:utils.fontSize]];
                
                if([((UILabel*)label).text isEqualToString:@"0"])
                    ((UILabel*)label).text=@"";
            }
        }
    }
    @catch (NSException *exception) {
        NSLog([NSString stringWithFormat:@"%@", exception.description]);
    }
    @finally {
        if(indexPath.row == array_price.count-1)
        {
            loadFull=NO;
            updating=NO;
        }
    }
    
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{return  25;}

- (void)dealloc {
    if(timer_price != nil){
        [timer_price invalidate];
        timer_price =nil;
    }
    [root_array_price release];
    //[array_price release];
    //[array_price_change release];
    [priceBoard release];
    [_priceBoard_header release];
    [_f_keyWord release];
    [_lbl_San release];
    [_btn_San release];
    [_btn_nganh release];
    [_lbl_Nganh release];
    [_bar_search release];
    [_btn_showMiniPriceBoard release];
    [_marketIndex release];
    [utils release];
    [queue cancelAllOperations];
    [queue release];
    [_btn_add release];
    [super dealloc];
}
@end





