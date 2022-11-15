//
//  ViewController.m
//  ProducerAndConsumer
//
//  Created by peak on 2022/11/15.
//

/// This demo inspire from
/// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/ThreadSafety/ThreadSafety.html

#import "ViewController.h"

#define HAS_DATA 0
#define NO_DATA 1

@interface ViewController ()
@property (nonatomic, strong) NSConditionLock *connditionLock;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSMutableArray *buffer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.connditionLock = [[NSConditionLock alloc] initWithCondition:NO_DATA];
    self.queue = dispatch_queue_create("producer.consumer.queue", DISPATCH_QUEUE_CONCURRENT);
    self.buffer = [NSMutableArray array];
    
    [self product];
    [self consume];
}

- (IBAction)doProduct:(id)sender {
    [self product];
}

- (void)product {
    dispatch_async(self.queue, ^{
        [self.connditionLock lock];
        // add data to the queue
        NSLog(@"[product] begin add to the buffer, current count: %lu, thread: %@", [self bufferCount], [NSThread currentThread]);
        int counts = arc4random_uniform(10);
        if (counts < 2) {
            counts = 2;
        }
        for (int i = 0; i < counts; i++) {
            NSString *msg = [self randomString];
            NSLog(@"[product] add data-%d: %@", i, msg);
            [self addDataToBuffer:msg];
        }
        NSLog(@"[product] finish add to the buffer");
        [self.connditionLock unlockWithCondition:HAS_DATA];
        NSLog(@"[product] changed lock condition to HAS_DATA");
    });
}

- (void)consume {
    dispatch_async(self.queue, ^{
        while (true) {
            [self.connditionLock lockWhenCondition:HAS_DATA];
            NSLog(@"\t[consume] begin consume data from buffer, current count: %lu, thread: %@", [self bufferCount], [NSThread currentThread]);
            NSArray *buffer = [self clearBuffer];
            for (NSString *msg in buffer) {
                NSLog(@"\t[consume] consume data: %@", msg);
            }
            NSLog(@"\t[consume] finish consume data from buffer");
            [self.connditionLock unlockWithCondition:NO_DATA];
            NSLog(@"\t[consume] changed lock condition to NO_DATA");
            printf("\n");
        }
    });
}

#pragma mark - Manipulate Data

- (void)addDataToBuffer:(NSString *)data {
    @synchronized (self) {
        [self.buffer addObject:data];
    }
}

- (NSUInteger)bufferCount {
    NSUInteger count = 0;
    @synchronized (self) {
        count = self.buffer.count;
    }
    return count;
}

- (NSArray *)clearBuffer {
    NSArray *buffer;
    @synchronized (self) {
        buffer = [NSArray arrayWithArray:self.buffer];
        [self.buffer removeAllObjects];
    }
    return buffer;
}


#pragma mark - Helper

- (NSString *)randomString {
    int len = arc4random_uniform(10);
    if (len < 1) {
        len = 1;
    }
    return [self randomStringWithLength:len];
}

- (NSString *)randomStringWithLength:(int)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
    for (int i = 0; i < len; i++) {
         [randomString appendFormat: @"%C", [letters characterAtIndex:arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

@end
