//
//  VDSCListSettingViewController.m
//  iPadDragon
//
//  Created by vdsc on 4/2/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCListSettingViewController.h"
#import "VDSCCommonUtils.h"
#import "VDSCListView.h"
#import "ASIFormDataRequest.h"

#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 3

@interface VDSCListSettingViewController ()
{
    VDSCCommonUtils *utils;
    BOOL dataChanging;
    
    NSOperationQueue *queue;
}
@end

@implementation VDSCListSettingViewController

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
    self.txt_giaVon.delegate=self;
    self.txt_tyLeCatLo.delegate=self;
    self.txt_giaCatLo.delegate=self;
    self.txt_tyLeChotLoi.delegate=self;
    self.txt_giaChotLoi.delegate=self;
	// Do any additional setup after loading the view.
    utils = [[VDSCCommonUtils alloc] init];
    dataChanging=NO;
    [self initData];
    
}
- (IBAction)txt_textChange:(id)sender {
    if(!dataChanging)
    {
        dataChanging=YES;
        double d=0;
        double giavon=[self.txt_giaVon.text doubleValue];
        if([sender isEqual:self.txt_giaCatLo])
        {
            d=[self.txt_giaCatLo.text doubleValue];
            self.txt_tyLeCatLo.text= [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:(d-giavon)*100/giavon]];
        }
        else
            if([sender isEqual:self.txt_tyLeCatLo])
            {
                d=[self.txt_tyLeCatLo.text doubleValue];
                self.txt_giaCatLo.text= [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:giavon-d/100*giavon]];
            }
        else if([sender isEqual:self.txt_giaChotLoi])
        {
            d=[self.txt_giaChotLoi.text doubleValue];
            self.txt_tyLeChotLoi.text= [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:(d-giavon)*100/giavon]];
        }
        else
            if([sender isEqual:self.txt_tyLeChotLoi])
            {
                d=[self.txt_tyLeChotLoi.text doubleValue];
                self.txt_giaChotLoi.text= [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:giavon+d/100*giavon]];
            }
            else{
                d=[self.txt_giaChotLoi.text doubleValue];
                self.txt_tyLeChotLoi.text= [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:(d-giavon)*100/giavon]];
                d=[self.txt_giaCatLo.text doubleValue];
                self.txt_tyLeCatLo.text= [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:(d-giavon)*100/giavon]];
            }

        dataChanging=NO;
    }
}

-(void) initData
{
    if(self.stockEntity.ChotLoi!=0)
        self.txt_giaChotLoi.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:self.stockEntity.ChotLoi]];
    if(self.stockEntity.CatLo!=0)
        self.txt_giaCatLo.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:self.stockEntity.CatLo]];
    if(self.stockEntity.GiaVon!=0)
    self.txt_giaVon.text = [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:self.stockEntity.GiaVon]];
    
    self.f_maCK.text = self.stockEntity.MaCK;
    [self txt_textChange:self.txt_giaVon];
    if(self.stockEntity.ChotLoi==0)
        self.txt_tyLeChotLoi.text=@"";
    if(self.stockEntity.CatLo==0)
        self.txt_tyLeCatLo.text=@"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_txt_giaChotLoi release];
    [_txt_giaCatLo release];
    [_txt_giaVon release];
    [_txt_tyLeChotLoi release];
    [_txt_tyLeCatLo release];
    [_f_maCK release];
    [utils release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTxt_giaChotLoi:nil];
    [self setTxt_giaCatLo:nil];
    [self setTxt_giaVon:nil];
    [self setTxt_tyLeChotLoi:nil];
    [self setTxt_tyLeCatLo:nil];
    [self setF_maCK:nil];
    [super viewDidUnload];
}
- (IBAction)btn_confirm_touch:(id)sender {
    if([self checkInputData]){
        NSArray *arr = [[NSArray alloc] initWithObjects:
                        @"KW_CLIENTSECRET",utils.clientInfo.secret
                        , @"KW_CLIENTID", utils.clientInfo.clientID
                        , @"KW_STOCKCODE", self.stockEntity.MaCK
                        , @"KW_MARKETID", self.stockEntity.SanGD
                        , @"KW_PROFITPRICE", self.txt_giaChotLoi.text.length==0?@"0":self.txt_giaChotLoi.text
                        , @"KW_LOSSPRICE", self.txt_giaCatLo.text.length==0?@"0":self.txt_giaCatLo.text
                        , @"KW_AVGPRICE", self.txt_giaVon.text
                        , nil];
        NSString *post = [utils postValueBuilder:arr];
        NSString *urlStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"updateCapitalPrice"];
        NSURL *url = [NSURL URLWithString:urlStr];
        ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
        request_cash.tag=100;
        
        [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
        [request_cash setRequestMethod:@"POST"];
        [self grabURLInTheBackground:request_cash];
        [arr release];
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
    NSLog(@"%@",error.description);
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
                //[utils showMessage:@"Cập nhật thành công" messageContent:nil];
                [((VDSCListView*)self.delegate) loadData];
                [((VDSCListView*)self.delegate).popover dismissPopoverAnimated:YES];
            }
            else[utils showMessage:@"Cập nhật không thành công" messageContent:nil];
        }
    }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
        @finally {
            if(allDataDictionary!=nil)
                [allDataDictionary release];
            
           
        }
    }

-(BOOL) checkInputData
{
    NSString *message=@"";
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    
    
    
    
    if([self.txt_giaChotLoi.text rangeOfCharacterFromSet:set].location != NSNotFound)
        message = [utils.dic_language objectForKey:@"ipad.list.worngProfitPrice"];
    else
    
    if([self.txt_giaCatLo.text rangeOfCharacterFromSet:set].location != NSNotFound)
        message = [NSString stringWithFormat:@"%@\n%@",message, [utils.dic_language objectForKey:@"ipad.list.worngLossPrice"]];
    else
    if([self.txt_giaVon.text isEqualToString:@""] || [self.txt_giaVon.text rangeOfCharacterFromSet:set].location != NSNotFound)
        message = [NSString stringWithFormat:@"%@\n%@",message, [utils.dic_language objectForKey:@"ipad.list.worngCapitalPrice"]];
    else
    if(self.txt_giaChotLoi.text.length>0 && ([self.txt_tyLeChotLoi.text doubleValue]<=0|| [self.txt_giaChotLoi.text isEqualToString: @"0"]))
        message = [NSString stringWithFormat:@"%@\n%@",message, [utils.dic_language objectForKey:@"ipad.list.worngProfitPrice"]];
    else
    if(self.txt_giaCatLo.text.length>0 && ([self.txt_tyLeCatLo.text doubleValue]>=0|| [self.txt_giaCatLo.text isEqualToString: @"0"]))
        message = [NSString stringWithFormat:@"%@\n%@",message, [utils.dic_language objectForKey:@"ipad.list.worngLossPrice"]];
    
    /*double chotLoi = [self.txt_giaChotLoi.text doubleValue];
    double catLo = [self.txt_giaCatLo.text doubleValue];
    double giaVon = [self.txt_giaVon.text doubleValue];
    if(self.stockEntity.ChotLoi == chotLoi && self.stockEntity.CatLo == catLo && self.stockEntity.GiaVon==giaVon)
        message = [NSString stringWithFormat:@"%@\n%@",message, @"Vui lòng nhập dữ liệu cần thay đổi"];*/
    
    if(message.length>0)[utils showMessage:@"Dữ liệu nhập không hợp lệ" messageContent:message];
    return message.length==0;
    
}

- (IBAction)btn_cancel_touch:(id)sender {
    [((VDSCListView*)self.delegate).popover dismissPopoverAnimated:YES];
}
@end
