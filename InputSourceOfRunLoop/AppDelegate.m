//
//  AppDelegate.m
//  RunLoopInputSouce
//
//  Created by s2mh on 26/05/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    NSMutableArray<RunLoopContext *> *sourcesToPing;
}

@end

@implementation AppDelegate

+ (instancetype)sharedAppDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        sourcesToPing = [NSMutableArray array];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [NSThread detachNewThreadSelector:@selector(threadMain) toTarget:self withObject:nil];
}

#pragma mark - Private

- (void)threadMain {
    RunLoopSource *source = [[RunLoopSource alloc] init];
    [source addToCurrentRunLoop];
    
    BOOL done = NO;
    do
    {
        NSLog(@"run loop will run");
        // Start the run loop but return after each source is handled.
        SInt32    result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 999, YES);
        
        
        // If a source explicitly stopped the run loop, or if there are no
        // sources or timers, go ahead and exit.
        if ((result == kCFRunLoopRunStopped) || (result == kCFRunLoopRunFinished))
            done = YES;
        
        // Check for any other exit conditions here and set the
        // done variable as needed.
    }
    while (!done);
}

#pragma mark - Public

- (void)registerSource:(RunLoopContext*)sourceInfo;
{
    [sourcesToPing addObject:sourceInfo];
}

- (void)removeSource:(RunLoopContext*)sourceInfo
{
    id    objToRemove = nil;
    
    for (RunLoopContext* context in sourcesToPing)
    {
        if (context.runLoop == sourceInfo.runLoop)
        {
            objToRemove = context;
            break;
        }
    }
    
    if (objToRemove)
        [sourcesToPing removeObject:objToRemove];
}

- (void)wakeSecondaryThreadRunLoopWithCommand:(NSString *)commandString {
    for (RunLoopContext *context in sourcesToPing) {
        RunLoopSource *source = context.source;
        [source addCommand:0 withData:commandString];
        [source fireAllCommandsOnRunLoop:context.runLoop];
    }
}

- (void)killSecondaryThreadRunLoop {
    for (RunLoopContext *context in sourcesToPing) {
        RunLoopSource *source = context.source;
        [source invalidate];
    }
}

@end
