//
//  ViewController.m
//  MutiThreadDemo
//
//  Created by Jason on 15/8/10.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>
#import "NavCustomViewController.h"
#import "aViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //派发队列
//    [self dispatchQueue];
    
    //派发队列组
//    [self dispatchQueueGroup];
    
    //NSOperation queue
    [self operationQueue];
    
    
    [self performSelector:@selector(push) withObject:self afterDelay:2];
}

- (void)push {
    NavCustomViewController *nav = [[NavCustomViewController alloc] initWithRootViewController:[[aViewController alloc] init]];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)operationQueue {
    //1. NSInvocationOperation对象
    // -- 同步执行
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(run:)
                                                                              object:nil];
    [operation start];
    
    //2. NSBlockOperation
    // -- 同步执行
    NSBlockOperation *operationBlock = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1- block %@", [NSThread currentThread]);
    }];
    //添加多个block
    // Operation 中的任务 会"并发执行"，它会 "在主线程和其它的多个线程" 执行这些任务
    for (NSInteger i = 0; i < 5; i++) {
        [operationBlock addExecutionBlock:^{
            NSLog(@"1- 第%ld次：%@", i, [NSThread currentThread]);
        }];
        if (i == 3) {
//            [operationBlock cancel];
        }
    }
    [operationBlock start];
    
    //3.创建自定义队列
    NSOperationQueue *customQueue = [[NSOperationQueue alloc] init];
    NSBlockOperation *block2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2- %@", [NSThread currentThread]);
    }];
    for (NSInteger i = 0; i < 9; i++) {
        [block2 addExecutionBlock:^{
            NSLog(@"2- 第%ld次： %@", i, [NSThread currentThread]);
        }];
        if (i == 0) {
            [block2 cancel];//取消任务
        }
    }

    //添加任务到队列中执行
    [customQueue addOperation:block2];
    
    [customQueue addOperationWithBlock:^{
        NSLog(@"再次执行");
    }];
    customQueue.maxConcurrentOperationCount = 1;
    [customQueue addOperationWithBlock:^{
        NSLog(@"hello world %@", [NSThread currentThread]);
    }];
}

- (void)run:(NSOperation *)operation {
    NSLog(@"%@", [NSThread currentThread]);
}

- (void)dispatchQueueGroup {
    //1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    //2.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //3.多次使用对嫘祖的方法执行任务，只有异步方法
    //3.1执行3次循环
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = 0; i < 7; i++) {
            NSLog(@"group-01 - %@", [NSThread currentThread]);
        }
    });
    
    //3.2祝队列执行3次循环
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 3; i++) {
            NSLog(@"group-02 - %@", [NSThread currentThread]);
        }
    });
    
    //3.3.执行5次循环
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = 0; i < 5; i++) {
            NSLog(@"group-03 - %@", [NSThread currentThread]);
        }
    });

    //4.都完成后会自动通知
    dispatch_group_notify(group, queue, ^{
        NSLog(@"完成 - %@", [NSThread currentThread]);
    });
    
    //4.都完成后会自动通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"完成 - %@", [NSThread currentThread]);
    });
}

- (void)dispatchQueue {
    //get main dispatch
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    //create serial queue
    dispatch_queue_t serialQueue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    
    //create concurrent queue
    dispatch_queue_t currentQueue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"当前 %@", [NSThread currentThread]);
    //同步任务
    dispatch_sync(currentQueue, ^{
        NSLog(@"我是 同步 并行任务 %@", [NSThread currentThread]);
    });
    
    dispatch_sync(serialQueue, ^{
        NSLog(@"我是 同步 串行任务 %@", [NSThread currentThread]);
    });
    
    
    //异步任务
    dispatch_async(serialQueue, ^{
        NSLog(@"我是 异步 串行任务 %@", [NSThread currentThread]);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"线程：%@", [NSThread currentThread]);
        });
        
    });
    
    dispatch_async(mainQueue, ^{
        NSLog(@"我是 异步 主队列 %@", [NSThread currentThread]);
    });
    
    dispatch_async(currentQueue, ^{
        NSLog(@"我是 异步 并行任务 %@", [NSThread currentThread]);
    });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"main? %@, name=%@", [NSThread currentThread], [NSThread currentThread].name);
    pthread_t thread;
    //创建一个线程并自动执行
    pthread_create(&thread, NULL, start, NULL);
    
}

void *start(void *data) {
    NSLog(@"%@", [NSThread currentThread]);
    return NULL;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
