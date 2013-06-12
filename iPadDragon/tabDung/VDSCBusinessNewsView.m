//
//  VDSCBusinessNewsView.m
//  iPadDragon
//
//  Created by vdsc on 1/14/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCBusinessNewsView.h"
#import "VDSCMarketIndexView.h"
#import "VDSCNewsEntity.h"

@interface VDSCBusinessNewsView()
{
    NSMutableArray *array;
    NSMutableData *webData;
    NSURLConnection *connection;
}

@end

@implementation VDSCBusinessNewsView

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
    
    [self.f_keyWord addTarget:self action:@selector(loadStockInfo) forControlEvents:UIControlEventEditingChanged];
    
    array = [[NSMutableArray alloc]init];
    
    self.tableNews.delegate = self;
    self.tableNews.dataSource = self;
    self.f_keyWord.text = @"VDS";
    //[self performSelectorInBackground:@selector(loadStockInfo) withObject:nil];
    [self loadStockInfo];
    
}
-(void) loadStockInfo
{
    NSString *code = self.f_keyWord.text;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://priceboard.vdsc.com.vn/ipad/dataInfo.jsp?code=%@&matchedIdx=-1&counter", code]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
        webData = [[NSMutableData alloc] init];
    
    [request release];
    //[connection release];
    //[url release];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
        [webData setLength:0];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Fail:********************");
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData  appendData:data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *err;
    NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:webData options:NSJSONReadingAllowFragments error:&err];
    if (err==Nil)
    {
        //NSLog([err description]);
        return;
    }
    [array removeAllObjects];
    NSArray *data_news = [allDataDictionary objectForKey:@"news"];
    if([data_news isEqual:[NSNull null]]){return;}
    self.f_ma.text = self.f_keyWord.text;
    self.f_ten.text = [allDataDictionary objectForKey:@"name"];
    
    for (NSArray *arrayOfEntity in data_news)
    {
        VDSCNewsEntity *news = [VDSCNewsEntity alloc];
        news.f_ID = [arrayOfEntity objectAtIndex:3];
        news.f_date = [arrayOfEntity objectAtIndex:0];
        news.f_title = [arrayOfEntity objectAtIndex:1];
        news.f_content = [arrayOfEntity objectAtIndex:2];
        
        [array addObject:news];
        [news release];
    }
    if(array!=nil && array.count>0)
    {
        
        VDSCNewsEntity *news = (VDSCNewsEntity*)[array objectAtIndex:0];
        [self setNewsData:news];
    }
    [webData release];
    [connection release];
    [self.tableNews reloadData];
    [self.f_keyWord resignFirstResponder];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{return 1;}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.f_keyWord resignFirstResponder];
    VDSCNewsEntity *news = (VDSCNewsEntity*)[array objectAtIndex:indexPath.row];
    [self setNewsData:news];
}
-(void) setNewsData:(VDSCNewsEntity *)news
{
    self.f_content.text = news.f_content;
    [self.f_webContent loadHTMLString:news.f_content baseURL:nil];
    self.f_title.text = news.f_title;
    self.f_date.text = news.f_date;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIndentifier = @"VDSCFullCellPrice";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableNews.frame.size.width, 50)];
    view.backgroundColor = [UIColor darkGrayColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.tableNews.frame.size.width-20, 25)];
    title.text=((VDSCNewsEntity*)[array objectAtIndex:indexPath.row]).f_title;
    title.font =[UIFont systemFontOfSize:15];
    title.textColor = [UIColor lightGrayColor];
    title.backgroundColor = [UIColor clearColor];
    [view addSubview:title];
    
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(230, 25, 80, 25)];
    date.text=((VDSCNewsEntity*)[array objectAtIndex:indexPath.row]).f_date;
    date.font =[UIFont systemFontOfSize:13];
    date.textColor = [UIColor yellowColor];
    date.backgroundColor = [UIColor clearColor];
    [view addSubview:date];
    
    [date release];
    [title release];
    
    [cell addSubview:view];
    return cell;
    
}
- (void)dealloc {
    [_marketInfo release];
    [_f_ma release];
    [_f_ten release];
    [_f_nganh release];
    [_f_keyWord release];
    [_tableNews release];
    [_f_content release];
    [_f_title release];
    [_f_date release];
    
    [array release];
    //[webData release];
    [_f_webContent release];
    [super dealloc];
}
- (IBAction)txt_ma_ValueChanged:(id)sender {
}

- (IBAction)btn_clear:(id)sender {
    self.f_keyWord.text=@"";
}
@end
