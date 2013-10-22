//
//  VDSCCommonUtils.m
//  iPadDragon
//
//  Created by vdsc on 1/4/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCCommonUtils.h"
#import "VDSCClientInfo.h"
#import "VDSCStock4OrderEntity.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@implementation VDSCCommonUtils
{
    NSOperationQueue *queue;
}

@synthesize numberFormatter;
@synthesize numberFormatter1Digits;
@synthesize numberFormatter2Digits;
@synthesize numberFormatter3Digits;
@synthesize c_koThayDoi;
@synthesize c_tran;
@synthesize c_san;
@synthesize c_tang;
@synthesize c_giam;
@synthesize c_thamChieu;
@synthesize shortDateFormater;
@synthesize longDateFormater;
@synthesize passExecutePrefix;
@synthesize keyParaKey;
@synthesize keyParaValue;
@synthesize dic_language;
@synthesize clientInfo;
@synthesize rowHeight;
@synthesize fontFamily;
@synthesize fontSize;
@synthesize cellBackgroundColor;

-(id)init
{
    self = [super init];
    //self.delegate = delegate;
    NSUserDefaults *client = [[NSUserDefaults standardUserDefaults] retain];
    clientInfo = [VDSCClientInfo alloc];
    clientInfo.clientID = [client objectForKey:@"clientID"];
    clientInfo.clientName = [client objectForKey:@"clientName"];
    clientInfo.tradingAccSeq = [client objectForKey:@"tradingAccSeq"];
    clientInfo.accountType = [client objectForKey:@"accountType"];
    clientInfo.secret = [client objectForKey:@"secret"];
    clientInfo.phone = [client objectForKey:@"phone"];
    clientInfo.email = [client objectForKey:@"email"];
    [client release];
    
    NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
    
    //NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"vi_VN"];
    
    numberFormatter= [[NSNumberFormatter alloc] init];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setLocale:locale];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    numberFormatter1Digits= [[NSNumberFormatter alloc] init];
    [numberFormatter1Digits setMaximumFractionDigits:1];
    [numberFormatter1Digits setLocale:locale];
    [numberFormatter1Digits setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter1Digits setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    numberFormatter2Digits = [[NSNumberFormatter alloc] init];
    [numberFormatter2Digits setMaximumFractionDigits:2];
    [numberFormatter2Digits setLocale:locale];
    [numberFormatter2Digits setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter2Digits setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    numberFormatter3Digits = [[NSNumberFormatter alloc] init];
    [numberFormatter3Digits setMaximumFractionDigits:3];
    [numberFormatter3Digits setLocale:locale];
    [numberFormatter3Digits setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter3Digits setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    
    shortDateFormater = [[NSDateFormatter alloc] init];
    //[shortDateFormater setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [shortDateFormater setDateFormat:@"dd/MM/yyyy"];//dd/MM/yyyy
    
    longDateFormater = [[NSDateFormatter alloc] init];
    [longDateFormater setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [longDateFormater setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    
    c_tran = [[UIColor colorWithRed:212/255.0 green:10/255.0 blue:201/255.0 alpha:1] retain];
    c_san = [[UIColor colorWithRed:5/255.0 green:193/255.0 blue:189/255.0 alpha:1] retain];
    c_thamChieu = [[UIColor colorWithRed:249/255.0 green:186/255.0 blue:75/255.0 alpha:1] retain];
    c_koThayDoi = [[UIColor colorWithRed:200/255.0 green:199/255.0 blue:68/255.0 alpha:1] retain];
    c_tang = [UIColor greenColor];//[[UIColor colorWithRed:0/255.0 green:178/255.0 blue:56/255.0 alpha:1] retain];
    self.c_giam = [UIColor redColor];//[[UIColor colorWithRed:191/255.0 green:0/255.0 blue:23/255.0 alpha:1] retain];
    
    self.soapMessage = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
    "<SOAP-ENV:Envelope \n"
    "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" \n"
    "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \n"
    "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" \n"
    "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" \n"
    "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"> \n"
    "<SOAP-ENV:Body> \n"
    "<%@ xmlns=\"http://tempuri.org/\"><info>%@</info>"
    "</%@> \n"
    "</SOAP-ENV:Body> \n"
    "</SOAP-ENV:Envelope>";
    
    passExecutePrefix=@"Abc123XYZ2013_";
    keyParaValue=@":::";
    keyParaKey=@"@@@";
    
    rowHeight=30;
    fontFamily=@"arial";
    fontSize=14;
    cellBackgroundColor = [[UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1] retain];
    [self initLanguage];
    return [self retain];
}-(void)initLanguage
{
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *xmlPath = [path stringByAppendingPathComponent:@"IdragonController_vi_VN.properties"];
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"defaultLanguage"] isEqual:@"EN"])
        xmlPath = [path stringByAppendingPathComponent:@"IdragonController_en_US.properties"];
    NSString *xmlString = [NSString stringWithContentsOfFile:xmlPath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray* singleStrs =[xmlString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    dic_language= [[NSMutableDictionary alloc] init];
    for(NSString *s in singleStrs)
    {
        NSRange range=[s rangeOfString:@" = "];
        if(range.location != NSNotFound){
            NSString *key=  [s substringToIndex:range.location];
            NSString *value=  [s substringFromIndex:range.location + 3];
            [dic_language setValue:value forKey:key];
        }
    }
}
-(NSString*) postValueBuilder:(NSArray*)params
{
    NSString *result=@"";
    result = [NSString stringWithFormat:@"%@%@",result, [NSString stringWithFormat:@"%@%@%@%@",@"KW_WS_EXECPWD",keyParaValue, [NSString stringWithFormat:@"%@%@",passExecutePrefix,[shortDateFormater stringFromDate: [NSDate date]]], keyParaKey]];
    int i=0;
    for(NSString *item in params)
    {
        if(i%2==0)
            result = [NSString stringWithFormat:@"%@%@",result, [NSString stringWithFormat:@"%@%@",item,keyParaValue]];
        else
            result = [NSString stringWithFormat:@"%@%@",result, [NSString stringWithFormat:@"%@%@",item, keyParaKey]];
        i+=1;
    }
    
    return [NSString stringWithFormat:@"info=%@",[result substringToIndex:[result length]-3]];
}
-(void) setLabelColor: (NSString *)color label:(UILabel *)label
{
    c_tran = [UIColor colorWithRed:212/255.0 green:10/255.0 blue:201/255.0 alpha:1];
    c_san = [UIColor colorWithRed:5/255.0 green:193/255.0 blue:189/255.0 alpha:1];
    c_thamChieu = [UIColor colorWithRed:249/255.0 green:186/255.0 blue:75/255.0 alpha:1];
    c_koThayDoi = [UIColor yellowColor];
    //[UIColor colorWithRed:200/255.0 green:199/255.0 blue:68/255.0 alpha:1];
    c_tang = [UIColor greenColor];//[[UIColor colorWithRed:0/255.0 green:178/255.0 blue:56/255.0 alpha:1] retain];
    c_giam = [UIColor redColor];//[[UIColor colorWithRed:191/255.0 green:0/255.0 blue:23/255.0 alpha:1] retain];
    
    if ([color isEqualToString:@"R"])
        label.textColor = c_thamChieu;
    else if ([color isEqualToString:@"C"])
        label.textColor = c_tran;
    else if ([color isEqualToString:@"F"])
        label.textColor = c_san;
    else if ([color isEqualToString:@"I"])
        label.textColor = c_tang;
    else if ([color isEqualToString:@"D"])
        label.textColor = c_giam;
    else if ([color isEqualToString:@"B"])
        label.textColor = c_tran;
    [label setBackgroundColor:[UIColor clearColor]];
}
-(UIColor*) getColor:(NSString*)color
{
    
    c_tran = [UIColor colorWithRed:212/255.0 green:10/255.0 blue:201/255.0 alpha:1];
    c_san = [UIColor colorWithRed:5/255.0 green:193/255.0 blue:189/255.0 alpha:1];
    c_thamChieu = [UIColor colorWithRed:249/255.0 green:186/255.0 blue:75/255.0 alpha:1];
    c_koThayDoi = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:68/255.0 alpha:1];
    c_tang = [[UIColor colorWithRed:0/255.0 green:178/255.0 blue:56/255.0 alpha:1] retain];
    c_giam = [[UIColor colorWithRed:191/255.0 green:0/255.0 blue:23/255.0 alpha:1] retain];
    
    if ([color isEqualToString:@"R"])
        return c_thamChieu;
    else if ([color isEqualToString:@"C"])
        return c_tran;
    else if ([color isEqualToString:@"F"])
        return  c_san;
    else if ([color isEqualToString:@"I"])
        return  c_tang;
    else if ([color isEqualToString:@"D"])
        return  c_giam;
    else if ([color isEqualToString:@"B"])
        return  c_tran;
    return [UIColor clearColor];
}


-(NSDictionary*) getDataFromUrl:(NSString *)strUrl method:(NSString*)method postData:(NSString*)postData
{
    NSDictionary *allDataDictionary=nil;
    @try {
        NSMutableData *post = [NSMutableData data];
        [post appendData:[postData dataUsingEncoding:NSUTF8StringEncoding]];
        NSURL *url = [NSURL URLWithString:strUrl];
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        [theRequest setHTTPMethod:method];
        if([method isEqualToString:@"POST"])
        {
            [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
            [theRequest setHTTPBody:post];
        }
        
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = [[NSError alloc] init];
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&urlResponse error:&error];
        //if(!error){
        if(responseData==nil || [responseData isEqual:[NSNull null]])
        {
            //[self showMessage:@"Khong the ket noi duoc he thong" messageContent:error.description];
            //[self showMessage:@"Khong the ket noi duoc he thong" messageContent:nil];
            //return nil;
        }
        else
        {
            allDataDictionary = [[NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil]retain];
            //return ;
        }
        //}
        //else [self showMessage:@"Khong the ket noi duoc he thong" messageContent:error.description];
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Kết nối server thất bại, vui lòng kiểm tra lại internet" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    @finally {
        return allDataDictionary;
    }
}
-(NSArray*)OTPRandomPosition
{
    int x = arc4random_uniform(5);
    int y = arc4random_uniform(5);
    NSString *row = @"";
    if(x==0)row=@"A";
    else if(x==1)row=@"B";
    else if(x==2)row=@"C";
    else if(x==3)row=@"D";
    else if(x==4)row=@"E";
    NSString *number1 = [NSString stringWithFormat:@"%@%d", row, y+1];
    
    x = arc4random_uniform(5);
    y = arc4random_uniform(5);
    row = @"";
    if(x==0)row=@"A";
    else if(x==1)row=@"B";
    else if(x==2)row=@"C";
    else if(x==3)row=@"D";
    else if(x==4)row=@"E";
    NSString *number2 = [NSString stringWithFormat:@"%@%d", row, y+1];
    
    NSArray *arr = [[[NSArray alloc] initWithObjects: number1, number2, nil] autorelease];
    return arr;
}
-(NSArray*)getOPTPosition: (NSString*)OTPPosition1 OTPPosition2:(NSString*)OTPPosition2
{
    NSString *x = @"";
    if([[OTPPosition1 substringToIndex:1] isEqualToString:@"A"])x=@"0";
    else if([[OTPPosition1 substringToIndex:1] isEqualToString:@"B"])x=@"1";
    else if([[OTPPosition1 substringToIndex:1] isEqualToString:@"C"])x=@"2";
    else if([[OTPPosition1 substringToIndex:1] isEqualToString:@"D"])x=@"3";
    else if([[OTPPosition1 substringToIndex:1] isEqualToString:@"E"])x=@"4";
    
    NSString *y = [NSString stringWithFormat:@"%d", [[OTPPosition1 substringFromIndex:1] intValue]-1];
    
    NSString *xx = @"";
    if([[OTPPosition2 substringToIndex:1] isEqualToString:@"A"])xx=@"0";
    else if([[OTPPosition2 substringToIndex:1] isEqualToString:@"B"])xx=@"1";
    else if([[OTPPosition2 substringToIndex:1] isEqualToString:@"C"])xx=@"2";
    else if([[OTPPosition2 substringToIndex:1] isEqualToString:@"D"])xx=@"3";
    else if([[OTPPosition2 substringToIndex:1] isEqualToString:@"E"])xx=@"4";
    
    NSString *yy = [NSString stringWithFormat:@"%d", [[OTPPosition2 substringFromIndex:1] intValue]-1];
    
    NSArray *arr = [[[NSArray alloc] initWithObjects: [NSString stringWithFormat:@"%@,%@", y,yy], [NSString stringWithFormat:@"%@,%@", x,xx], nil] autorelease];
    return arr;
}
-(BOOL)otpCherker:(NSString*)OTPPosition1 OTPPosition2:(NSString*)OTPPosition2  OTPPosition1_Value:(NSString*)OTPPosition1_Value OTPPosition2_value:(NSString*)OTPPosition2_Value isSave:(BOOL)isSave
{
    NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"OTPChecker"];
    NSArray *arr_otp = [self getOPTPosition:OTPPosition1 OTPPosition2:OTPPosition2];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:
                    @"KW_CLIENTSECRET",self.clientInfo.secret
                    , @"KW_CLIENTID", self.clientInfo.clientID
                    , @"KW_OTP_ROWIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:0]]
                    , @"KW_OTP_COLIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:1]]
                    , @"KW_OTP_VALUE",[NSString stringWithFormat:@"%@,%@",OTPPosition1_Value,OTPPosition2_Value]
                    , @"KW_OTP_SAVE",isSave?@"10":@"0"
                    , nil];
    NSString *post = [self postValueBuilder:arr];
    NSDictionary *allDataDictionary = [[self getDataFromUrl:url method:@"POST" postData:post] retain];
    if([[allDataDictionary objectForKey:@"success"] boolValue])
    {
        if(isSave){
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setBool:YES forKey:@"saveOTP"];
            [user synchronize];
        }
        [arr release];
        [allDataDictionary release];
        return YES;
    }
    else{
        
        [arr release];
        [allDataDictionary release];
        return NO;
    }
    [arr release];
    [arr_otp release];
}
-(void)showMessage:(NSString*)messageCaption messageContent:(NSString*)messageContent
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:messageCaption message:messageContent delegate:self cancelButtonTitle:@"Đóng" otherButtonTitles:nil, nil];
    alert.frame = CGRectMake(0, 0, 300, 300);
    /*if(messageContent!=nil && messageContent.length>0)
     {
     UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(50, 50, 200, 100)];
     textView.text = messageContent;
     [textView setEditable:NO];
     [alert addSubview:textView];
     }*/
    [alert show];
}
-(void)showMessage:(NSString*)messageCaption messageContent:(NSString*)messageContent dismissAfter:(int)dismissAfter
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:messageCaption message:messageContent delegate:self cancelButtonTitle:@"Đóng" otherButtonTitles:nil, nil];
    alert.frame = CGRectMake(0, 0, 300, 300);
    [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:dismissAfter];
    [alert show];
}
-(void)dismissAlert:(UIAlertView*)alertView{
	[alertView dismissWithClickedButtonIndex:-1 animated:YES];
}

- (IBAction) showConfirmMessae:(id)sender delegate:(id)delegate message:(NSString*)message{
    // create a simple alert with an OK and cancel button
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:message
                          message:nil
                          delegate:delegate
                          cancelButtonTitle:@"No"
                          otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert release];
}
-(void)addStock2WatchingList:(NSString*) stockId marketId:(NSString*) marketId
{
    NSArray *arr = [[NSArray alloc] initWithObjects:
                    @"KW_CLIENTSECRET",self.clientInfo.secret
                    , @"KW_CLIENTID", self.clientInfo.clientID
                    , @"KW_STOCKCODE", [stockId uppercaseString]
                    , @"KW_MARKETID", [marketId uppercaseString]
                    , nil];
    NSString *post = [self postValueBuilder:arr];
    NSString *urlStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"addWatchingStock"];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
    request_cash.tag=100;
    [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
    [request_cash setRequestMethod:@"POST"];
    [self grabURLInTheBackground:request_cash];
    [arr release];
}
-(void)removeStock2WatchingList:(NSString*) stockId marketId:(NSString*) marketId
{
    NSArray *arr = [[NSArray alloc] initWithObjects:
                    @"KW_CLIENTSECRET",self.clientInfo.secret
                    , @"KW_CLIENTID", self.clientInfo.clientID
                    , @"KW_STOCKCODE", [stockId uppercaseString]
                    , @"KW_MARKETID", [marketId uppercaseString]
                    , nil];
    NSString *post = [self postValueBuilder:arr];
    NSString *urlStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"removeWatchingStock"];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
    request_cash.tag=200;
    [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
    [request_cash setRequestMethod:@"POST"];
    [self grabURLInTheBackground:request_cash];
    
    [arr release];
}
-(VDSCStock4OrderEntity*) loadStockInfo:(NSString*)stockId marketId:(NSString*) marketId orderSide:(NSString*)orderSide
{
    VDSCStock4OrderEntity *entity = [[[VDSCStock4OrderEntity alloc] init] autorelease];
    marketId = marketId == nil?@"HO":[marketId uppercaseString];
    @try{
    NSArray *arr = [[NSArray alloc] initWithObjects:
                    @"KW_CLIENTSECRET",self.clientInfo.secret
                    , @"KW_CLIENTID", self.clientInfo.clientID
                    , @"KW_STOCKCODE", stockId
                    , @"KW_MARKETID", marketId
                    , @"KW_ORDER_SIDE", orderSide
                    , nil];
    NSString *post = [self postValueBuilder:arr];
    NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"stock4Order"];
    NSDictionary *allDataDictionary = [[self getDataFromUrl:url method:@"POST" postData:post] retain];
    if(![allDataDictionary isEqual:[NSNull null]])
    {
        if([[allDataDictionary objectForKey:@"success"] boolValue])
        {
            NSArray *array = [allDataDictionary objectForKey:@"stock"] ;
            if(![array isEqual:[NSNull null]])
            {
                entity.reference=[[array objectAtIndex:0] floatValue];
                entity.ceiling=[[array objectAtIndex:2] doubleValue];
                entity.floor=[[array objectAtIndex:1] doubleValue];
                entity.marketId = [array objectAtIndex:7];
                entity.status = [array objectAtIndex:3];
                entity.name = [array objectAtIndex:4];
                entity.nameEN = [array objectAtIndex:5];
                entity.usable = [[allDataDictionary objectForKey:@"usableBal"] doubleValue];
                entity.block = [[array objectAtIndex:6] doubleValue];
            }
            entity.marketStatus = [allDataDictionary objectForKey:@"marketStatus"];
        }
    }
    [arr release];
    [allDataDictionary release];
    }
    @catch (NSException *ex) {
        NSLog(ex.description);
    }
    return  entity;
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
    NSDictionary *allDataDictionary;
    @try{
        NSData *data = [request responseData];
        allDataDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] retain];
        if(request.tag==100)
        {
            if([[allDataDictionary objectForKey:@"success"] boolValue])
            {
                //[self showMessage:[dic_language objectForKey:@"ipad.watchingList.addSuccess"] messageContent:nil dismissAfter:2];
            }
        }
        else {
            if([[allDataDictionary objectForKey:@"success"] boolValue])
            {
                //[self showMessage:[dic_language objectForKey:@"ipad.watchingList.removeSuccess"] messageContent:nil dismissAfter:2];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(exception.description);
    }
    @finally {
        if(allDataDictionary!=nil)
            [allDataDictionary release];
        
    }
    
}

- (void)requestWentWrong:(ASIFormDataRequest *)request
{
    NSError *error = [request error];
    NSLog(error.description);
}


-(UIWebView*)showLoading:(UIView*)onView
{
    UIWebView *view = [[[UIWebView alloc] init] autorelease];
    view.backgroundColor=[UIColor clearColor];// self.cellBackgroundColor;
    [view setOpaque:NO];
    [view setUserInteractionEnabled:NO];
    CGRect rect = CGRectMake(onView.frame.size.width/2-50, onView.frame.size.height/2-50, 100, 100);
    view.frame=rect;//http://www.faadooengineers.com/plugin_scripts/social-login/img/loading.gif
    [view loadHTMLString:@"<img src=\"http://www.csnigeria.org/csn/images/icon_loading.gif\" width=\"64px\" height=\"64px\"/>" baseURL:nil];
    [onView addSubview:view];
    
    return view;
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


-(void) dealloc
{
    [clientInfo release];
    /*[c_giam release];
    [c_koThayDoi release];
    [c_san release];
    [c_tang release];
    [c_thamChieu release];
    [c_tran release];*/
    [numberFormatter release];
    [numberFormatter2Digits release];
    [numberFormatter3Digits release];
    [queue cancelAllOperations];
    [queue release];
    [super dealloc];
}
@end
