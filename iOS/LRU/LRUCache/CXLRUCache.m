//
//  LRUCache.m
//  LRUCache
//
//  Created by chenxi on 2020/6/29.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import "CXLRUCache.h"

@interface ListNode : NSObject

@property (nonatomic, weak) ListNode *prev;
@property (nonatomic, weak) ListNode *next;

@property (nonatomic, strong) id key;
@property (nonatomic, strong) id value;

- (instancetype)initWithKey:(id)key withValue:(id)value;
@end

@implementation ListNode

- (instancetype)initWithKey:(id)key withValue:(id)value {
    if (self = [super init]) {
        _key = key;
        _value = value;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"node dealloc. %@ : %@", self.key, self.value);
}
@end


@interface CXLRUCache ()
@property (nonatomic, assign) int cap;
@property (nonatomic, strong) NSMutableDictionary *cache;
@property (nonatomic, strong) ListNode *head;
@property (nonatomic, strong) ListNode *tail;
@end

@implementation CXLRUCache

- (instancetype)initWithCapacity:(int)capacity {
    self = [super init];
    _cap = capacity;
    _cache = [NSMutableDictionary dictionary];
    _head = [[ListNode alloc] initWithKey:@"_head_" withValue:@"internal_head"];
    _tail = [[ListNode alloc] initWithKey:@"_tail_" withValue:@"internal_tail"];
    _head.next = _tail;
    _tail.prev = _head;
    return self;
}

- (void)put:(id)key value:(id)value {
    if ([self.cache objectForKey:key]) {
        ListNode *node = [self.cache objectForKey:key];
        [self removeNode:node];
    }
    
    ListNode *node = [[ListNode alloc] initWithKey:key withValue:value];
    
    [self.cache setObject:node forKey:key];
    [self pushNodeToFront:node];
    
    if (self.cache.count > self.cap) {
        ListNode *lastNode = self.tail.prev;
        [self removeNode:lastNode];
        [self.cache removeObjectForKey:lastNode.key];
    }
}

- (id)get:(id)key {
    if (!key) return nil;
    
    if ([self.cache objectForKey:key]) {
        ListNode *node = [self.cache objectForKey:key];
        [self removeNode:node];
        [self pushNodeToFront:node];
        return node.value;
    } else {
        return nil;
    }
}

- (NSArray *)allValues {
    NSMutableArray *values = [NSMutableArray array];
    ListNode *nextNode = self.head.next;
    while (nextNode && nextNode.value && ![nextNode isEqual:self.tail]) {
        [values addObject:nextNode.value];
        nextNode = nextNode.next;
    }
    return values;
}

- (void)pushNodeToFront:(ListNode *)node {
    // second will become third node
    ListNode *secondNode = self.head.next;
    self.head.next = node;
    node.next = secondNode;
    node.prev = self.head;
    secondNode.prev = node;
}

- (void)removeNode:(ListNode *)node {
    if (node.next) {
        node.next.prev = node.prev;
    }
    if (node.prev) {
        node.prev.next = node.next;
    }
}



@end
