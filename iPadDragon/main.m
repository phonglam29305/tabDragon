//
//  main.m
//  iPadDragon
//
//  Created by vdsc on 12/24/12.
//  Copyright (c) 2012 VDSC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VDSCAppDelegate.h"

int main(int argc, char *argv[])
{
    /*@autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([VDSCAppDelegate class]));
    }*/
    int retVal = -1;
    @autoreleasepool {
        @try {
            retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([VDSCAppDelegate class]));
        }
        @catch (NSException* exception) {
            NSLog(@"Uncaught exception: %@", exception.description);
            NSLog(@"Stack trace: %@", [exception callStackSymbols]);
        }
    }
    return retVal;
}
