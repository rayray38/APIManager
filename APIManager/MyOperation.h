//
//  MyOperation.h
//  APIManager
//
//  Created by RayRayDer on 2015/11/23.
//  Copyright © 2015年 rayer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MyOperationState) {
    MyOperationReadyState = 1,
    MyOperationExecutingState,
    MyOperationFinishedState
};

typedef void (^MyOperationAction)(void);

@interface MyOperation : NSOperation {
    MyOperationAction _action;
    MyOperationState _state;
    BOOL _cancel;
}

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, copy) MyOperationAction action;
@property (nonatomic, assign) MyOperationState state;
@property (nonatomic, readonly, getter = isCancelled) BOOL cancel;

- (id)initWithAction:(MyOperationAction)action;
+ (void)keepThreadAlive;
+ (NSThread*)threadForMyOperation;
- (void)start;
- (void)operationDidStart;
- (void)runOperations;
- (void)runOperationsatCustomQueue;

@end
