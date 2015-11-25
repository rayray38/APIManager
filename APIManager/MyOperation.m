//
//  MyOperation.m
//  APIManager
//
//  Created by RayRayDer on 2015/11/23.
//  Copyright © 2015年 rayer. All rights reserved.
//

#import "MyOperation.h"

@implementation MyOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 5;
    }
    return self;
}

- (id)initWithAction:(MyOperationAction)action
{
    return self;
}

+ (void)keepThreadAlive
{
    do {
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] run];
        }
    } while (YES);
}

+ (NSThread*)threadForMyOperation
{
    static NSThread* _threadInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _threadInstance = [[NSThread alloc] initWithTarget:self
                                                  selector:@selector(keepThreadAlive)
                                                    object:nil];
        _threadInstance.name = @"MyOperation.Thread";
        [_threadInstance start];
    });
    return _threadInstance;
}

- (void)start
{
    // do something here
    if([self isReady]) {
        
        [self willChangeValueForKey:@"isExecuting"];
        [self willChangeValueForKey:@"isReady"];
        _state = MyOperationExecutingState;
        [self didChangeValueForKey:@"isReady"];
        [self didChangeValueForKey:@"isExecuting"];
        
        [self performSelector:@selector(operationDidStart)
                     onThread:[[self class] threadForMyOperation]
                   withObject:nil
                waitUntilDone:NO];
    }
}

- (void)operationDidStart
{
    if(self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isCancelled"];
        _state = MyOperationFinishedState;
        [self didChangeValueForKey:@"isCancelled"];
        [self didChangeValueForKey:@"isFinished"];
    } else {
        NSLog(@"Operation is running %@ thread", [NSThread currentThread]);
        self.action();
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        _state = MyOperationFinishedState;
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];
    }
}

- (void)runOperations
{
    MyOperation* myOperation = [[MyOperation alloc] initWithAction:^{
        NSLog(@"this is MyOperation");
    }];
    
    NSBlockOperation* blockOperation = [[NSBlockOperation alloc] init];
    [blockOperation addExecutionBlock:^{
        NSLog(@"this is block Operation");
    }];
    
    [myOperation start];
    [blockOperation start];
}

- (void)runOperationsatCustomQueue
{
    NSBlockOperation* blockOperation01 = [[NSBlockOperation alloc] init];
    [blockOperation01 addExecutionBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"this is no.1 block Operation");
    }];
    
    NSBlockOperation* blockOperation02 = [[NSBlockOperation alloc] init];
    [blockOperation02 addExecutionBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"this is no.2 block Operation, start sleep 1 second");
        sleep(1);
        NSLog(@"no.2 wake up.");
    }];
    
    NSBlockOperation* blockOperation03 = [[NSBlockOperation alloc] init];
    [blockOperation03 addExecutionBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"this is no.3 block Operation, no.2 operation is completed, start task");
    }];
    
    [blockOperation03 addDependency:blockOperation02];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue setSuspended:YES];
    [queue setMaxConcurrentOperationCount:5];
    [queue addOperation:blockOperation01];
    [queue addOperation:blockOperation02];
    [queue addOperation:blockOperation03];
    [queue setSuspended:NO];
}

#pragma mark - Override

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return self.state == MyOperationExecutingState;
}

- (BOOL)isFinished
{
    return self.state == MyOperationFinishedState;
}

- (BOOL)isReady
{
    return self.state == MyOperationReadyState;
}

- (void)cancel
{
    [self willChangeValueForKey:@"isCancelled"];
    _cancel = YES;
    [self didChangeValueForKey:@"isCancelled"];
    // 如果你的Operation是執行一些資料處理 or request, 可以做一些其他的處理
}

@end
