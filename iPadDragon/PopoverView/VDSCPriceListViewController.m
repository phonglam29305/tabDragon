//
//  VDSCPriceListViewController.m
//  iPadDragon
//
//  Created by vdsc on 1/10/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCPriceListViewController.h"

@interface VDSCPriceListViewController ()
{
    NSArray *source;
    NSMutableArray *array_index;
    NSMutableData *webData_index;
    NSURLConnection *connection_index;
}
@end

@implementation VDSCPriceListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //if(self.type_1list_2category == 1)
    source = [[NSArray alloc] initWithObjects:@"HOSE", @"VN30", @"HNX", @"HNX30", @"UPCOM", @"Danh mục quan tâm", nil];
    //else source = [[NSArray alloc] initWithObjects:@"HOSE", @"VN30", @"HNX", @"HNX30", @"UPCOM", @"Danh mục quan tâm", nil];
    self.tableView.delegate=self;
    self.tableView.dataSource = self;
	
    if(self.type_1list_2category==2){
        array_index = [[NSMutableArray alloc] init];
        [self loadData];
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{return 1;}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{return 30;}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.type_1list_2category==1)
        return source.count;
    else return array_index.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"VDSCFullCellPrice";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        [cell autorelease];
    }
    if(self.type_1list_2category==1)
        cell.textLabel.text = [source objectAtIndex:indexPath.row];
    else
    {
        if(array_index!=nil && array_index.count>0)
        {
            NSArray *array = [array_index objectAtIndex:indexPath.row];
            cell.textLabel.text = [ array objectAtIndex:1];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        
            cell.tag = [[[array_index objectAtIndex:indexPath.row] objectAtIndex:0] integerValue];
        }
    }
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.type_1list_2category==1)
    {
        self.marketInfo.lbl_San.text = [source objectAtIndex:indexPath.row];
        self.marketInfo.lbl_Nganh.text= @"Tất cả";
        self.marketInfo.lbl_Nganh.tag=0;
    }
    else {
        self.marketInfo.lbl_Nganh.text = [[array_index objectAtIndex:indexPath.row] objectAtIndex:1];
        self.marketInfo.lbl_Nganh.tag = [[[array_index objectAtIndex:indexPath.row] objectAtIndex:0] integerValue];
    }
    [self.marketInfo dismissPopoverController:self.marketInfo.popover];
}
-(void) loadData
{
    NSURL *url = [NSURL URLWithString:@"http://priceboard.vdsc.com.vn/ipad/sectors.jsp?langId=vi_VN"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //if (connection_index ==nil) {
        connection_index = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        //connection_index
        if(connection_index)
            webData_index = [[NSMutableData alloc] init];
    //}
    [request release];
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
    NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:webData_index options:0 error:nil];
    NSDictionary *list = [allDataDictionary objectForKey:@"list"];
    NSArray *array = [[NSArray alloc] initWithObjects:@"0",@"Tất cả", nil];
    [array_index addObject:array];
    for(NSArray *data in list)
    {
        [array_index addObject:data];
    }
    [self.tableView reloadData];
    [array release];
    [connection_index release];
    connection_index =nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
}
-(void)viewWillDisappear:(BOOL)animated
{
    if(source!=nil)
    [source release];
    [_tableView release];
    if(array_index!=nil)
    [array_index release];
    if(webData_index!=nil)
    [webData_index release];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
