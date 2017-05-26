//
//  RunLoopSource.m
//  StreetScroller
//
//  Created by s2mh on 26/05/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "RunLoopSource.h"
#import "AppDelegate.h"

void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    RunLoopSource* obj = (__bridge RunLoopSource*)info;
    AppDelegate*   del = [AppDelegate sharedAppDelegate];
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
    
    [del performSelectorOnMainThread:@selector(registerSource:)
                          withObject:theContext waitUntilDone:NO];
    NSLog(@"run loop is scheduled");
}

void RunLoopSourcePerformRoutine (void *info)
{
    NSLog(@"run loop is awaked");
    RunLoopSource*  obj = (__bridge RunLoopSource*)info;
    [obj sourceFired];
}

void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    NSLog(@"run loop is cancelled");
    RunLoopSource* obj = (__bridge RunLoopSource*)info;
    AppDelegate* del = [AppDelegate sharedAppDelegate];
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
    
    [del performSelectorOnMainThread:@selector(removeSource:)
                          withObject:theContext waitUntilDone:YES];
}

@implementation RunLoopSource

- (id)init
{
    CFRunLoopSourceContext    context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
        &RunLoopSourceScheduleRoutine,
        RunLoopSourceCancelRoutine,
        RunLoopSourcePerformRoutine};
    
    runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
    commands = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)addToCurrentRunLoop
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(runLoop, runLoopSource, kCFRunLoopDefaultMode);
}

- (void)invalidate {
    CFRunLoopSourceInvalidate(runLoopSource);
}

- (void)sourceFired {
    NSLog(@"run loop logs:");
    for (id command in commands) {
        NSLog(@"%@", command);
    }
}

// Client interface for registering commands to process
- (void)addCommand:(NSUInteger)command withData:(id)data {
    [commands insertObject:data atIndex:command];
}

- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop {
    CFRunLoopSourceSignal(runLoopSource);
    CFRunLoopWakeUp(runloop);
}

@end

@implementation RunLoopContext

@synthesize runLoop = runLoop;
@synthesize source = source;

- (instancetype)initWithSource:(RunLoopSource *)src andLoop:(CFRunLoopRef)loop
{
    self = [super init];
    if (self) {
        runLoop = loop;
        source = src;
    }
    return self;
}

@end
