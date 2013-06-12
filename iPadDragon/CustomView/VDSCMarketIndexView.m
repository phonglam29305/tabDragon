//
//  VDSCMarketIndexView.m
//  iPadDragon
//
//  Created by vdsc on 1/14/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCMarketIndexView.h"
#import "VDSCMainViewController.h"

@interface VDSCMarketIndexView()
{
    NSMutableArray *array_index;
    NSMutableData *webData_index;
    NSURLConnection *connection_index;
    NSTimer *timer_index;
    
    NSTimer *timer_marqueeIndex;
    bool start;
    VDSCCommonUtils *utils;
}

@end

@implementation VDSCMarketIndexView

@synthesize ho_index;
@synthesize ho30_index;
@synthesize ha_index;
@synthesize ha30_index;
@synthesize upcom_index;

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
    [self loadMarketIndex];
    utils = [[VDSCCommonUtils alloc] init];
    [super awakeFromNib];
    array_index = [[NSMutableArray alloc] init];
    
    
    timer_index= [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
    [timer_index fire];
    
    //timer_marqueeIndex= [NSTimer scheduledTimerWithTimeInterval:35.0 target:self selector:@selector(loadMarqueeData) userInfo:nil repeats:YES];
    //[timer_marqueeIndex fire];
    
    start = YES;
    
}
-(void) loadMarketIndex
{
    @try{
        ho_index = [[[NSBundle mainBundle] loadNibNamed:@"VDSCMarketIndex" owner:self options:nil] objectAtIndex:0];
        ho_index.frame = CGRectMake(5,2,192,60);
        [ho_index setBackgroundColor:[UIColor greenColor]];
        [ho_index initValue:[[VDSCIndexEntity alloc] initWithObjects:@"VN-INDEX" :@"0" :@"0" :@"0" :@"0" :@"0" :@"R"]];
        [self.marketIndex addSubview:ho_index];
        
        int x=ho_index.frame.origin.x+ho_index.frame.size.width+2;
        ho30_index = [[[NSBundle mainBundle] loadNibNamed:@"VDSCMarketIndex" owner:self options:nil] objectAtIndex:0];
        ho30_index.frame = CGRectMake(x,2,192,60);
        [ho30_index setBackgroundColor:[UIColor redColor]];
        [ho_index initValue:[[VDSCIndexEntity alloc] initWithObjects:@"VN30-INDEX" :@"0" :@"0" :@"0" :@"0" :@"0" :@"R"]];
        [self.marketIndex addSubview:ho30_index];
        
        x=ho30_index.frame.origin.x+ho30_index.frame.size.width+2;
        ha_index = [[[NSBundle mainBundle] loadNibNamed:@"VDSCMarketIndex" owner:self options:nil] objectAtIndex:0];
        ha_index.frame = CGRectMake(x,2,192,60);
        [ha_index setBackgroundColor:[UIColor brownColor]];
        [ho_index initValue:[[VDSCIndexEntity alloc] initWithObjects:@"HNX-INDEX" :@"0" :@"0" :@"0" :@"0" :@"0" :@"R"]];
        [self.marketIndex addSubview:ha_index];
        
        x=ha_index.frame.origin.x+ha_index.frame.size.width+2;
        ha30_index = [[[NSBundle mainBundle] loadNibNamed:@"VDSCMarketIndex" owner:self options:nil] objectAtIndex:0];
        ha30_index.frame = CGRectMake(x,2,192,60);
        [ha30_index setBackgroundColor:[UIColor darkGrayColor]];
        [ho_index initValue:[[VDSCIndexEntity alloc] initWithObjects:@"HNX30-INDEX" :@"0" :@"0" :@"0" :@"0" :@"0" :@"R"]];
        [self.marketIndex addSubview:ha30_index];
        
        x=ha30_index.frame.origin.x+ha30_index.frame.size.width+2;
        upcom_index = [[[NSBundle mainBundle] loadNibNamed:@"VDSCMarketIndex" owner:self options:nil] objectAtIndex:0];
        upcom_index.frame = CGRectMake(x,2,192,60);
        [upcom_index setBackgroundColor:[UIColor orangeColor]];
        [ho_index initValue:[[VDSCIndexEntity alloc] initWithObjects:@"UPCOM-INDEX" :@"0" :@"0" :@"0" :@"0" :@"0" :@"R"]];
        [self.marketIndex addSubview:upcom_index];
        
        
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData_index setLength:0];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Fail:********************");
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData_index appendData:data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if(webData_index == nil)return;
    
    [array_index removeAllObjects];
    
    NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:webData_index options:0 error:nil];
    //NSDictionary *list = [allDataDictionary objectForKey:@"list"];
    NSArray *arrayOfEntity = [allDataDictionary objectForKey:@"hsx"];
    
    VDSCIndexEntity *index = [[VDSCIndexEntity alloc]init];
    if(![arrayOfEntity isEqual:[NSNull null]]){
        
        index.marketName=@"VN-INDEX";
        index.mark = [arrayOfEntity objectAtIndex:0];
        index.change = [arrayOfEntity objectAtIndex:1];
        double d = [[arrayOfEntity objectAtIndex:2] doubleValue];
        NSString *xxx = [utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: d]];
        index.changePer =[NSString stringWithFormat:@"%@ %@", [arrayOfEntity objectAtIndex:10],xxx];
        index.value = [arrayOfEntity objectAtIndex:3];
        index.amount = [arrayOfEntity objectAtIndex:4];
        index.color= [arrayOfEntity objectAtIndex:11];
        [array_index addObject:index];
        [index release];
    }
    
    arrayOfEntity = [allDataDictionary objectForKey:@"vn30"];
    if(![arrayOfEntity isEqual:[NSNull null]]){
        index = [[VDSCIndexEntity alloc]init];
        index.marketName=@"VN30-INDEX";
        index.mark = [arrayOfEntity objectAtIndex:0];
        index.change = [arrayOfEntity objectAtIndex:1];
        double d = [[arrayOfEntity objectAtIndex:2] doubleValue];
        NSString *xxx = [utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: d]];
        index.changePer =[NSString stringWithFormat:@"%@ %@", [arrayOfEntity objectAtIndex:10],xxx];
        
        index.value = [arrayOfEntity objectAtIndex:3];
        index.amount = [arrayOfEntity objectAtIndex:4];
        index.color= [arrayOfEntity objectAtIndex:11];
        [array_index addObject:index];
        [index release];
    }
    
    arrayOfEntity = [allDataDictionary objectForKey:@"hnx"];
    if(![arrayOfEntity isEqual:[NSNull null]]){
        index = [[VDSCIndexEntity alloc]init];
        index.marketName=@"HNX-INDEX";
        index.mark = [arrayOfEntity objectAtIndex:0];
        index.change = [arrayOfEntity objectAtIndex:1];
        double d = [[arrayOfEntity objectAtIndex:2] doubleValue];
        NSString *xxx = [utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: d]];
        index.changePer =[NSString stringWithFormat:@"%@ %@", [arrayOfEntity objectAtIndex:10],xxx];
        index.value = [arrayOfEntity objectAtIndex:3];
        index.amount = [arrayOfEntity objectAtIndex:4];
        index.color= [arrayOfEntity objectAtIndex:11];
        [array_index addObject:index];
        [index release];
    }
    
    
    arrayOfEntity = [allDataDictionary objectForKey:@"hnx30"];
    if(![arrayOfEntity isEqual:[NSNull null]]){
        index = [[VDSCIndexEntity alloc]init];
        index.marketName=@"HNX30-INDEX";
        index.mark = [arrayOfEntity objectAtIndex:0];
        index.change = [arrayOfEntity objectAtIndex:1];
        double d = [[arrayOfEntity objectAtIndex:2] doubleValue];
        NSString *xxx = [utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: d]];
        index.changePer =[NSString stringWithFormat:@"%@ %@", [arrayOfEntity objectAtIndex:10],xxx];
        index.value = [arrayOfEntity objectAtIndex:3];
        index.amount = [arrayOfEntity objectAtIndex:4];
        index.color= [arrayOfEntity objectAtIndex:11];
        [array_index addObject:index];
        [index release];
    }
    
    
    arrayOfEntity = [allDataDictionary objectForKey:@"upcom"];
    if(![arrayOfEntity isEqual:[NSNull null]]){
        index = [[VDSCIndexEntity alloc]init];
        index.marketName=@"UPCOM-INDEX";
        index.mark = [arrayOfEntity objectAtIndex:0];
        index.change = [arrayOfEntity objectAtIndex:1];
        double d = [[arrayOfEntity objectAtIndex:2] doubleValue];
        NSString *xxx = [utils.numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble: d]];
        index.changePer =[NSString stringWithFormat:@"%@ %@", [arrayOfEntity objectAtIndex:10],xxx];
        index.value = [arrayOfEntity objectAtIndex:3];
        index.amount = [arrayOfEntity objectAtIndex:4];
        index.color= [arrayOfEntity objectAtIndex:11];
        [array_index addObject:index];
        [index release];
    }
    
    
    [self reloadData];
    
}
-(void) loadData
{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:[user stringForKey:@"market_info"]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //if (connection_index ==nil) {
    connection_index = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //connection_index
    //if(connection_index)
    webData_index = [[NSMutableData alloc] init];
    //}
    [request release];
    [connection_index release];
    //connection_index = nil;
    //NSLog(@"load index");
}
-(void) reloadData
{
    //if(start) [self loadMarqueeData];
    
    if(ho_index ==nil)[self loadMarketIndex];
    //NSLog(((VDSCIndexEntity *)[array objectAtIndex:0]).amount);
    [ho_index initValue:[array_index objectAtIndex:0]];
    [ho30_index initValue:[array_index objectAtIndex:1]];
    [ha_index initValue:[array_index objectAtIndex:2]];
    [ha30_index initValue:[array_index objectAtIndex:3]];
    [upcom_index initValue:[array_index objectAtIndex:4]];
}
-(void)loadMarqueeData
{
    VDSCMainViewController *main = self.delegate;
    if(main.f_marqueeIndex !=nil){
        [main.f_marqueeIndex loadHTMLString:[self htmlBuilder] baseURL:nil];
        start = NO;
    }
    //NSLog(@"load marquee index");
}

-(NSString*)htmlBuilder
{
    NSString *content = @"";
    if(array_index!=nil && array_index.count>0)
    {
        
        for(VDSCIndexEntity *index in array_index)
        {
            NSString *color=@"red";
            if([index.color isEqualToString:@"R"])
                color=@"yellow";
            else
                if([index.color isEqualToString:@"I"])
                    color=@"green";
            
            double d = [index.value doubleValue]/1000000;
            NSString *value=[NSString stringWithFormat:@"%@",[[self.delegate utils].numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            d = [index.amount doubleValue]/1000000;
            NSString *amount=[NSString stringWithFormat:@"%@",[[self.delegate utils].numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            d = [index.mark doubleValue];
            NSString *mark=[NSString stringWithFormat:@"%@",[[self.delegate utils].numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            d = [index.change doubleValue];
            NSString *change=[NSString stringWithFormat:@"%@",[[self.delegate utils].numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            d = [index.changePer doubleValue];
            NSString *changePer=[NSString stringWithFormat:@"%@",[[self.delegate utils].numberFormatter2Digits stringFromNumber:[NSNumber numberWithDouble:d]]];
            content =[NSString stringWithFormat:@"%@%@", content,[NSString stringWithFormat:@"<label style=\"color: %@\">%@ %@ %@(%@) - KLGD:%@ - GTGD:%@ </label> ", color,index.marketName, mark, change, index.changePer, value, amount]];
        }
    }
    NSString *html = [NSString stringWithFormat:@"<html><head></head><body style=\"margin: 0 0 0 0\"><marquee style=\"width: 769px; height: 30px; padding-top: 5px; font-style: arial\">%@</marquee></body></html>", content];
    
    return html;
}
- (void)dealloc {
    [timer_index invalidate];
    //[timer_marqueeIndex invalidate];
    //timer_marqueeIndex = nil;
    timer_index=nil;
    [array_index release];
    [webData_index release];
    [ho30_index release];
    [ho_index release];
    [ha30_index release];
    [ha_index release];
    [upcom_index release];
    [_marketIndex release];
    [utils release];
    [super dealloc];
}
@end
