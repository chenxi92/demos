//
//  YYCache.m
//  LRUCache
//
//  Created by chenxi on 2020/6/29.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import "YYCache.h"

@interface _YYLinkedMapNode : NSObject {
    @package
    __unsafe_unretained _YYLinkedMapNode *_prev; // retained by dic
    __unsafe_unretained _YYLinkedMapNode *_next; // retained by dic
    id _key;
    id _value;
}
@end
@implementation _YYLinkedMapNode
@end

@interface _YYLinkedMap : NSObject {
    @package
    CFMutableDictionaryRef _dic;
    _YYLinkedMapNode *_head;
    _YYLinkedMapNode *_tail;
}

- (void)insertNodeAtHead:(_YYLinkedMapNode *)node;
- (void)bringNodeToHead:(_YYLinkedMapNode *)node;
- (void)removeNode:(_YYLinkedMapNode *)node;
- (_YYLinkedMapNode *)removeTailNode;
- (void)removeAll;
@end

@implementation _YYLinkedMap

- (instancetype)init {
    if (self = [super init]) {
        _dic = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }
    return self;
}

- (void)dealloc {
    CFRetain(_dic);
}

- (void)insertNodeAtHead:(_YYLinkedMapNode *)node {
    CFDictionarySetValue(_dic, (__bridge const void *)(node->_key), (__bridge const void *)(node));
    if (_head) {
        node->_next = _head;
        _head->_prev = node;
        _head = node;
    } else {
        _head = _tail = node;
    }
}

- (void)bringNodeToHead:(_YYLinkedMapNode *)node {
    if (_head == node) {
        return;
    }
    
    if (_tail == node) {
        // move tail node
        _tail = node -> _prev;
        _tail -> _next = nil;
    } else {
        // delete node from list
        node->_next->_prev = node->_prev;
        node->_prev->_next = node->_next;
    }
    
    // bring node to head
    node->_next = _head;
    node->_prev = nil;
    _head->_prev = node;
    
    // recode head
    _head = node;
}

- (void)removeNode:(_YYLinkedMapNode *)node {
    CFDictionaryRemoveValue(_dic, (__bridge const void *)node->_key);
    
    // delete node from list
    if (node->_next) { // not tail
        node->_next->_prev = node->_prev;
    }
    if (node->_prev) { // not head
        node->_prev->_next = node->_next;
    }
    
    // recode head/tail
    if (_head == node) {
        _head = node->_next;
    }
    if (_tail == node) {
        _tail = node->_prev;
    }
}

- (_YYLinkedMapNode *)removeTailNode {
    if (!_tail) {
        return nil;
    }
    _YYLinkedMapNode *tail = _tail;
    CFDictionaryRemoveValue(_dic, (__bridge const void *)tail->_key);
    
    if (_head == _tail) {
        // only one element
        _head = _tail = nil;
    } else {
        _tail = _tail ->_prev;
        _tail->_next = nil;
    }
    return tail;
}

- (void)removeAll {
    _head = _tail = nil;
    if (CFDictionaryGetCount(_dic) > 0) {
        CFMutableDictionaryRef holder = _dic;
        _dic = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        
        // hold and release async
        dispatch_async(dispatch_get_main_queue(), ^{
            CFRelease(holder);
        });
    }
}
@end

@implementation YYCache {
    _YYLinkedMap *_lru;
    dispatch_queue_t _queue;
    int _capatity;
}

- (instancetype)initWithCapatity:(int)capatity {
    if (self = [super init]) {
        _lru = [_YYLinkedMap new];
        _capatity = capatity;
    }
    return self;
}


- (void)dealloc {
    [_lru  removeAll];
    NSLog(@"dealloc YYCache.");
}

- (BOOL)contailsObjectForKey:(id)key {
    if (!key) return NO;
    BOOL contains = CFDictionaryContainsKey(_lru->_dic, (__bridge const void*)key);
    return contains;
}

- (id)objectForKey:(id)key {
    if (!key) return nil;
    _YYLinkedMapNode *node = CFDictionaryGetValue(_lru->_dic, (__bridge const void*)key);
    if (node) {
        [_lru bringNodeToHead:node];
    }
    return node ? node->_value : nil;
}

- (void)setObject:(id)object forKey:(id)key {
    _YYLinkedMapNode *node = CFDictionaryGetValue(_lru->_dic, (__bridge const void*)key);
    if (node) {
        node->_value = object;
        [_lru bringNodeToHead:node];
    } else {
        node = [_YYLinkedMapNode new];
        node->_key = key;
        node->_value = object;
        [_lru insertNodeAtHead:node];
    }
    if (CFDictionaryGetCount(_lru->_dic) > _capatity) {
        _YYLinkedMapNode *tailNode = [_lru removeTailNode];
        if (tailNode->_key) {
            CFDictionaryRemoveValue(_lru->_dic, (__bridge const void *)(tailNode->_key));
        }
    }
}

- (void)removeObjectForKey:(id)key {
    if (!key) return;
    _YYLinkedMapNode *node = CFDictionaryGetValue(_lru->_dic, (__bridge const void*)key);
    if (node) {
        [_lru removeNode:node];
        
        // hole and release in queue
        dispatch_async(dispatch_get_main_queue(), ^{
            [node class];
        });
    }
}

- (void)removeAllObjects {
    [_lru removeAll];
}

- (NSArray *)allObjects {
    NSMutableArray *objects = [NSMutableArray array];
    _YYLinkedMapNode *node = _lru->_head;
    while (node && node->_value) {
        [objects addObject:node->_value];
        node = node->_next;
    }
    return objects;
}
@end
