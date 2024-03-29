//
//  VDSCOrderUtility.m
//  iPadDragon
//
//  Created by vdsc on 4/21/13.
//  Copyright (c) 2013 VDSC. All rights reserved.
//

#import "VDSCOrderUtility.h"
#import "VDSCPriceBoardEntity.h"
#import "VDSCSystemParams.h"
#import "VDSCOTPView.h"
#import "ASIFormDataRequest.h"
#import "VDSCOrderView.h"
#import "VDSCEditOrderViewController.h"


@implementation VDSCOrderUtility
{
    NSMutableDictionary *array;
    NSOperationQueue *queue;
    double  temp;
    NSString *orderTypeID;
}

@synthesize utils;

-(VDSCOrderUtility*)init
{
    self = [VDSCOrderUtility alloc];
    [self initDataOrderErrorCode];
    return self;
}
-(BOOL) checkContrain:(NSString*)orderType stockEntity:(VDSCPriceBoardEntity*)stockEntity params:(VDSCSystemParams*)params orderSide:(NSString*)orderSide price:(double)price qty:(double)qty amountWithFee:(double)amountWithFee isGtdOrder:(BOOL)isGtdOrder otpView:(VDSCOTPView*)otpView stock4Order:(VDSCStock4OrderEntity*)stock4Order
{
    @try{
    BOOL result = YES;
    NSString *message = @"";
    
    // kiem tra chon ma ck chua
    if(stockEntity == nil)
        message = [utils.dic_language objectForKey:@"ipad.order.notStockInput"];
    else{
        
        //if(!result)
        //    message = [NSString stringWithFormat:@"%@\n%@",message, @"Bạn chưa chọn mã chứng khoán"];
        
        //kiem tra loai lenh
        orderTypeID=@"";
        if([stockEntity.f_sanGD isEqualToString:@"HO"])
        {
            result = NO;
            for(NSArray *type in params.hsxOrderType)
            {
                result=[orderType isEqualToString:[type objectAtIndex:1]];
                if(result) {orderTypeID = [type objectAtIndex:0]; break;}
            }
            
        }
        else if([stockEntity.f_sanGD isEqualToString:@"HA"])
        {
            result = NO;
            for(NSArray *type in params.hnxOrderType)
            {
                result=[orderType isEqualToString:[type objectAtIndex:1]];
                if(result) {orderTypeID = [type objectAtIndex:0]; break;}
            }
        }
        else if([stockEntity.f_sanGD isEqualToString:@"OTC"])
        {
            result = NO;
            for(NSArray *type in params.upcomOrderType)
            {
                result=[orderType isEqualToString:[type objectAtIndex:1]];
                if(result) {orderTypeID = [type objectAtIndex:0]; break;}
            }
        }
        if(!result)
            message = [NSString stringWithFormat:@"%@\n%@",message, [utils.dic_language objectForKey:@"ipad.order.worngOrderType"]];
        //kiem tra buoc price
        if(isGtdOrder)
            result=YES;
        else
            result = (price>=stock4Order.floor && price <=stock4Order.ceiling);
        
        int step_value=0;
        if(result )//&& !([orderType isEqualToString:@"MOK"]||[orderType isEqualToString:@"MAK"]||[orderType isEqualToString:@"MTL"]))
        {
            result = price>0;
            if(result){
                price = price*1000;
                double step=0;
                double oldstep=0;
                if([stockEntity.f_sanGD isEqualToString:@"HO"])
                {
                    //result = NO;
                    int i=0;
                    for(id pricebyStep in [params.hoseStepPrice objectAtIndex:0])
                    {
                        step = [pricebyStep doubleValue]*1000;
                        if(price<step && price>oldstep)
                        {
                            int pri = [[NSString stringWithFormat:@"%f", price] intValue];
                            step_value = [[[params.hoseStepPrice objectAtIndex:1] objectAtIndex:i] doubleValue]*1000;
                            int x = pri% step_value;
                            
                            result= x==0;
                            if(!result) break;
                        }
                        oldstep=step;
                        i+=1;
                    }
                }
                else if([stockEntity.f_sanGD isEqualToString:@"HA"])
                {
                    //result = NO;
                    int i=0;
                    for(id pricebyStep in [params.hnxStepPrice objectAtIndex:0])
                    {
                        step = [pricebyStep doubleValue]*1000;
                        if(price<step)
                        {
                            int pri = [[NSString stringWithFormat:@"%f", price] intValue];
                            step_value = [[[params.hoseStepPrice objectAtIndex:1] objectAtIndex:i] doubleValue]*1000;
                            int x = pri% step_value;
                            
                            result= x==0;
                            if(!result) break;
                        }
                        i+=1;
                    }
                }
                else if([stockEntity.f_sanGD isEqualToString:@"OTC"])
                {
                    //result = NO;
                    int i=0;
                    for(id pricebyStep in [params.upcomStepPrice objectAtIndex:0])
                    {
                        step = [pricebyStep doubleValue]*1000;
                        if(price<step)
                        {
                            int pri = [[NSString stringWithFormat:@"%f", price] intValue];
                            step_value = [[[params.hoseStepPrice objectAtIndex:1] objectAtIndex:i] doubleValue]*1000;
                            int x = pri% step_value;
                            
                            result= x==0;
                            if(!result) break;
                        }
                        i+=1;
                    }
                }
            }
            if(!result)
            {
                NSString *alert = [NSString stringWithFormat:[utils.dic_language objectForKey:@"ipad.order.worngStepPrice"],step_value];
                message = [NSString stringWithFormat:@"%@\n%@",message, alert];
            }
        }
        else
        {
            message = [NSString stringWithFormat:[utils.dic_language objectForKey:@"ipad.order.worngPrice"],message
                       , [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:stock4Order.floor]], [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:stock4Order.ceiling]]];
        }
        
        //}
        // kiem tra khoi luong
        
        result=qty>0;
        if(!([orderTypeID isEqualToString:@"L"] && qty<100 && [stock4Order.marketId isEqualToString:@"HA"])){//lo le san hnx
            if(result){
                float x = fmod(qty, stock4Order.block);
                result = x==0;
            }
            if(!result)
                message = [NSString stringWithFormat:@"%@\n%@",message, [NSString stringWithFormat:[utils.dic_language objectForKey:@"ipad.order.worngQty"],[utils.numberFormatter stringFromNumber:[NSNumber numberWithDouble:stock4Order.block]]]];
        }
        
        //kiem tra price tri dat so voi suc mua
        if([orderSide isEqualToString:@"B"])
        {
            if(amountWithFee > stock4Order.usable)
            {
                //result=NO;
                message = [NSString stringWithFormat:@"%@\n%@",message, [NSString stringWithFormat:[utils.dic_language objectForKey:@"ipad.order.worngBuyAmount"], [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:stock4Order.usable]]]];
            }
        }
        else{
            if(qty>stock4Order.usable){
                //result=NO;
                message = [NSString stringWithFormat:@"%@\n%@",message, [NSString stringWithFormat:[utils.dic_language objectForKey:@"ipad.order.worngSellQty"], [utils.numberFormatter3Digits stringFromNumber:[NSNumber numberWithDouble:stock4Order.usable]]]];
            }
            
        }
        if(message.length==0 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"saveOTP"])
        {
            if([otpView checkInput]){
                BOOL result = [utils otpCherker:otpView.otp_number1.text OTPPosition2:otpView.otp_number2.text OTPPosition1_Value:otpView.otp_number1Value.text OTPPosition2_value:otpView.otp_number2Value.text isSave:NO];
                if(!result)
                {
                    [utils showMessage:[utils.dic_language objectForKey:@"ipad.otp.saveFail"] messageContent:nil ];
                    return NO;
                }
                
            }
            else return NO;
        }
    }
    if(message.length!=0)
    {
        [utils showMessage:@"Thông tin lệnh không hợp lệ." messageContent:message];
        [otpView resetOtpPosition];
        
    }
    
    return message.length==0;
        
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
        return NO;
    }
}
-(NSString*)checkOrderMarket:(NSString*)orderType marketId:(NSString*)marketId stockCode:(NSString*)stockCode orderSide:(NSString*)orderSide
{
    @try{
    NSString *result = @"";
    if([orderType isEqualToString:@"ATC"] ||[orderType isEqualToString:@"C"] )
        orderType=@"ATC";
    else if([orderType isEqualToString:@"LO"] ||[orderType isEqualToString:@"L"] )
        orderType=@"L";
    if([orderType isEqualToString:@"ATC"] && [orderSide isEqualToString:@"E"])
    {
        result=@"Lệnh ATC không được sửa.";
        return  result;
    }
    else{
        if(stockCode == nil || [stockCode isEqualToString:@""]){result=@"Vui lòng nhập mã chứng khoán.";
            return  result;}
        VDSCStock4OrderEntity *stock4Order = [utils loadStockInfo:stockCode marketId:marketId orderSide:@"B"];
        if(stock4Order!=Nil && stock4Order.ceiling==0){result=[NSString stringWithFormat: @"Không tồn tại mã chứng khoán: %@",stockCode];
            return  result;}
        if(![stock4Order.status isEqualToString:@"Listed"])
        {
            result=@"Mã chứng khoán ngừng giao dịch.";
            return  result;
        }
        if([marketId isEqualToString:@"HA"])
        {
            //1: khop lenh lien tuc
            //1.1 mua/ban chap nhan tat ca loai lenh(lo le phai nho hon 100, chi duoc dat loailenh LO)
            //1.2 sua LO-Chua khop MTL(phan con lai chuyen thanh LO)-lo le
            // truong hop sua lo le thi khong sua thanh lo chan
            // MOK, MAK khong dc sua
            
            //1.3 huy
            // chi huy dc LO-lole
            
            //2: khop lenh dinh ky
            //1.1 mua/ban
            //chi chap nhan LO+ATC
            //1.2 sua
            //chi dc sua LO
            //1.3 huy
            // chi huy dc 5 phut dau phien
            
            // gia dat theo gia khop lenh hien tai
            //MOK: Khop het hoac huy het ngay khi lenh vao san
            //MAK: Khop mot phan, phan con lai huy ngay khi lenh vao san
            //MTL: khop het hoac khop 1 phan, phan con lai chuyen sang LO ngay khi vao san
            
            
            
            if([stock4Order.marketStatus isEqualToString:@""] || stock4Order.marketStatus == nil)//ngoai gio dat lenh
            {
                result=@"Ngoài giờ đặt lệnh";
                return  result;
            }
            else if([stock4Order.marketStatus isEqualToString:@"LIS_CON_NML_1"])//lien tuc
            {
                if(!([orderType isEqualToString:@"L"]||[orderType isEqualToString:@"ATC"]) && ([orderSide isEqualToString:@"C"] || [orderSide isEqualToString:@"E"]))
                {
                    result=@"Chỉ được huỷ/sửa lệnh LO trong phiên khớp lệnh liên tục";
                    return  result;
                }
            }
            else if([stock4Order.marketStatus isEqualToString:@"LIS_AUC_C_NML_1"])//dinh ky 10 phut dau phien
            {
                if(!([orderType isEqualToString:@"ATC"] || [orderType isEqualToString:@"L"])&& ([orderSide isEqualToString:@"C"] || [orderSide isEqualToString:@"E"]))
                {
                    result=@"Quý khách chỉ được huỷ lệnh LO - ATC hoặc sửa lệnh LO trong phiên này.";
                    return  result;
                }
                if(!([orderType isEqualToString:@"ATC"] || [orderType isEqualToString:@"L"]) && ([orderSide isEqualToString:@"B"] || [orderSide isEqualToString:@"S"]))
                {
                    result=@"Quý khách chỉ được phép đặt lệnh LO - ATC trong phiên này" ;
                    return  result;
                }
            }
            else if([stock4Order.marketStatus isEqualToString:@"LIS_AUC_C_NML_LOC_1"])//dinh ky 5 phut cuoi phien
            {
                if([orderSide isEqualToString:@"C"] || [orderSide isEqualToString:@"E"])
                {
                    result=@"Quý khách không được Huỷ/Sửa trong phiên này";
                    return  result;
                }
                else if(!([orderType isEqualToString:@"ATC"] || [orderType isEqualToString:@"L"]) && ([orderSide isEqualToString:@"B"] || [orderSide isEqualToString:@"S"]))
                {
                    result=@"Quý khách chỉ được phép đặt lệnh LO - ATC trong phiên này" ;
                    return  result;
                }
            }
            else if([stock4Order.marketStatus isEqualToString:@"TP"])
            {
                result=@"Không được đặt lệnh trong thời gian nghỉ giữa phiên";
                return  result;
            }
            else if([stock4Order.marketStatus isEqualToString:@"NONE_07"]|[stock4Order.marketStatus isEqualToString:@"NONE_97"]||[stock4Order.marketStatus isEqualToString:@"LIS_PTH_P_NML_13"]||[stock4Order.marketStatus isEqualToString:@"LIS_PTH_P_NML_1"])
            {
                result=@"Đặt lệnh không thành công. Đã hết giờ giao dịch, quý khách chỉ có thể đặt lệnh cho phiên giao dịch kế tiếp.";
                return  result;
            }
        }
    }
        return result;
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
        return ex.description;
    }
}
- (BOOL)sendOrder:(NSString*)orderType stockEntity:(VDSCPriceBoardEntity*)stockEntity params:(VDSCSystemParams*)params orderSide:(NSString*)orderSide price:(double)price qty:(double)qty amountWithFee:(double)amountWithFee isGtdOrder:(BOOL)isGtdOrder gtdDate:(NSString*)gtdDate otpView:(VDSCOTPView*)otpView
{
    @try{
    if(!isGtdOrder){
        NSString *checkMarketStatus = [self checkOrderMarket:orderType marketId:stockEntity.f_sanGD stockCode:stockEntity.f_maCK orderSide:orderSide];
        if(checkMarketStatus.length>0)
        {
            [utils showMessage:checkMarketStatus messageContent:nil dismissAfter:3];
            return NO;
        }}
    VDSCStock4OrderEntity *stock4Order = [utils loadStockInfo:stockEntity.f_maCK marketId:stockEntity.f_sanGD orderSide:orderSide];
    if([self checkContrain:orderType stockEntity:stockEntity params:params orderSide:orderSide price:price qty:qty amountWithFee:amountWithFee isGtdOrder:isGtdOrder otpView:otpView stock4Order:stock4Order])
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSArray *arr = nil;// NSDictionary *allDataDictionary = nil;
        NSString *urlStr = [NSString stringWithFormat:@"%@",[user stringForKey:@"createOrder"]];
        NSArray *arr_otp = [utils getOPTPosition:otpView.otp_number1.text OTPPosition2:otpView.otp_number2.text];
        
        double maxOrderQty=0;
        double orderQty=0;
        temp=qty;
        if([stockEntity.f_sanGD isEqualToString:@"HO"])
            maxOrderQty = params.hoseMaxOrderQty;
        else if([stockEntity.f_sanGD isEqualToString:@"HA"])
            maxOrderQty = params.hnxMaxOrderQty;
        else if([stockEntity.f_sanGD isEqualToString:@"OTC"])
            maxOrderQty = params.upcomMaxOrderQty;
        //int i=0;
        while (temp>0) {
            if(temp >= maxOrderQty){
                orderQty = maxOrderQty;
                temp -=orderQty;
            }
            else
            {
                orderQty = temp;
                temp=0;
            }
            
            arr = [[NSArray alloc] initWithObjects:
                   @"KW_CLIENTSECRET",utils.clientInfo.secret
                   , @"KW_CLIENTID", utils.clientInfo.clientID
                   , @"KW_ORDER_SIDE", orderSide
                   , @"KW_ORDER_CODE",stockEntity.f_maCK
                   , @"KW_ORDER_PRICE", [NSString stringWithFormat:@"%f", price]
                   , @"KW_ORDER_QTY",[NSString stringWithFormat:@"%d", (int)orderQty]
                   , @"KW_ORDER_TYPE", orderTypeID
                   , @"KW_ORDER_GTD", isGtdOrder? gtdDate:@""
                   , @"KW_OTP_ROWIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:0]]
                   , @"KW_OTP_COLIDX",[NSString stringWithFormat:@"%@",[arr_otp objectAtIndex:1]]
                   , @"KW_OTP_VALUE",[NSString stringWithFormat:@"%@,%@",otpView.otp_number1Value.text,otpView.otp_number2Value.text]
                   , nil];
            NSString *post = [utils postValueBuilder:arr];
            /*allDataDictionary = [utils getDataFromUrl:urlStr method:@"POST" postData:post];
             if([[allDataDictionary objectForKey:@"success"] boolValue])
             {
             i+=1;
             }*/
            
            NSURL *url = [NSURL URLWithString:urlStr];
            ASIFormDataRequest *request_cash = [ASIFormDataRequest requestWithURL:url ];
            request_cash.tag=temp;
            
            [request_cash addPostValue:[post substringFromIndex:5] forKey:@"info"];
            [request_cash setRequestMethod:@"POST"];
            [self grabURLInTheBackground:request_cash];
            [arr release];
        }
        /* if(i>0)
         {
         //if(i>1)
         [utils showMessage:[NSString stringWithFormat:@"Đặt lệnh thành công %d lệnh",i] messageContent:nil];
         //else
         return YES;
         }
         else{
         
         [utils showMessage:@"Đặt lệnh không thành công" messageContent:[self getErrorMessage: [allDataDictionary objectForKey:@"errCode"]]];
         
         [arr release];
         [allDataDictionary release];
         return NO;
         }*/
    }
        
    }
    @catch (NSException *ex) {
        NSLog(@"Uncaught exception: %@", ex.description);NSLog(@"Stack trace: %@", [ex callStackSymbols]);
    }
    return NO;
    
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
        NSError *err;
        allDataDictionary = [[NSJSONSerialization JSONObjectWithData:[request responseData] options: NSJSONReadingAllowFragments error:&err] retain];
        if(![[allDataDictionary objectForKey:@"success"] boolValue])
        {
            [utils showMessage:@"Đặt lệnh không thành công" messageContent:[self getErrorMessage: [allDataDictionary objectForKey:@"errCode"]] dismissAfter:2];
        }
        else
        {
            if(request.tag==0)
            {
                [utils showMessage:[utils.dic_language objectForKey:@"ipad.order.orderSuccess"] messageContent:nil dismissAfter:2];
                if([self.delegate isKindOfClass:[VDSCOrderView class]])
                {
                    VDSCOrderView *order = (VDSCOrderView*)self.delegate;
                    [order loadOrders];
                    [order clearInputData];
                }
                else
                {
                    VDSCEditOrderViewController *order = (VDSCEditOrderViewController*)self.delegate;
                    [order loadOrders];
                    [order clearInputData];
                }
                
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
-(NSString*)getErrorMessage:(NSString*)errCode
{
    NSString *errMessage = [array objectForKey:errCode];
    if(errMessage.length==0)
        errMessage=errCode;
    
    return errMessage;
}
-(void) initDataOrderErrorCode
{
    array = [[NSMutableDictionary alloc] init];
    
    [array setValue:@"Pwd Data bị hết hạn." forKey:@"ERRCODE_9999"];
    [array setValue:@"Mã xác thực không đúng." forKey:@"ERRCODE_6666"];
    [array setValue:@"Ngày GTD ko hợp lệ vì đó ko phải là ngày giao dịch" forKey:@"HKSFOE00031"];
    [array setValue:@"Ngày GTD quá xa so với hệ thống" forKey:@"HKSFOE00008"];
    [array setValue:@"Mua bán cùng phiên (lệnh mua/bán đối ứng còn hiệu lực)" forKey:@"HKSFOE00050"];
    [array setValue:@"Trạng thái lệnh đã thay đổi. Thường gặp khi Hủy lệnh bị lỗi" forKey:@"HKSFOE00005"];
    [array setValue:@"Tài khoản này Hủy lệnh của tài khoản khác, hoặc tài khoản Hủy lệnh ko phải của mình" forKey:@"ERRCODE_CANCELORDER_NOTAVAILABLE"];
    [array setValue:@"Ngoài thời gian cho phép hủy lệnh" forKey:@"ERRCODE_CANCELORDER_TIME4CANCEL"];
    [array setValue:@"Không đủ tiền trong trường hợp Đặt lệnh + Sửa lệnh" forKey:@"HKSRISK0018"];
    [array setValue:@"Ko có tồn tại Order có orderId gởi lên" forKey:@"ERRCODE_EDITORDER_NONEORDER_4EDIT"];
    [array setValue:@"Tài khoản này Sửa lệnh của tài khoản khác, hoặc tài khoản Hủy lệnh ko phải của mình" forKey:@"ERRCODE_EDITORDER_NOTAVAILABLE"];
    [array setValue:@"Không đủ tiền trong trường hợp Đặt lệnh + Sửa lệnh" forKey:@"HKSRISK0018"];
    
    [array setValue:@"Chỉ hỗ trợ đặt lệnh loại O,C,M,L" forKey:@"ERRCODE_ORDER_NOT_SUPPORT_ORDERTYPE"];
    [array setValue:@"B, S" forKey:@"ERRCODE_ORDER_NOT_SUPPORT_ORDERSIDE"];
    [array setValue:@"Không đủ sức mua" forKey:@"ERRCODE_ORDER_ACCOUNT_CASH"];
    [array setValue:@"Không đủ chứng khoán" forKey:@"ERRCODE_ORDER_ACCOUNT_STOCK"];
    [array setValue:@"Ngoài giờ đặt lệnh" forKey:@"ERRCODE_ORDER_TIME4ORDER"];
    [array setValue:@"Thao tác không sẵn sàng và lúc này. Vui lòng thử lại" forKey:@"HKSSC0004"];
    [array setValue:@"Thao tác không sẵn sàng và lúc này. Vui lòng thử lại" forKey:@"ERRCODE_8888"];
    [array setValue:@"Mật khẩu đã bị hết hạn. Quý khách vui lòng restart lại ứng dụng." forKey:@"ERRCODE_9999"];
    
    
}
@end
