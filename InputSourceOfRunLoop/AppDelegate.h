//
//  AppDelegate.h
//  RunLoopInputSouce
//
//  Created by s2mh on 26/05/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunLoopSource.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)sharedAppDelegate;

- (void)registerSource:(RunLoopContext*)sourceInfo;
- (void)removeSource:(RunLoopContext*)sourceInfo;

- (void)wakeSecondaryThreadRunLoopWithCommand:(NSString *)commandString;
- (void)killSecondaryThreadRunLoop;

@end

