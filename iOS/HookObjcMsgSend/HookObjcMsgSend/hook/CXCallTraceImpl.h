//
//  Created by peak on 2021/1/22.
//

#ifndef CXCallTraceImpl_h
#define CXCallTraceImpl_h

#include <stdio.h>
#include <objc/objc.h>

typedef struct {
    __unsafe_unretained Class cls;
    SEL sel;
    uint64_t time;
    int depth;
} cxCallRecord;

extern void cxCallTraceStrat(void);
extern void cxCallTraceStop(void);

extern void cxCallConfigMinTime(uint64_t us);
extern void cxCallConfigMaxDepth(int depth);

extern cxCallRecord *cxGetCallRecords(int *num);
extern void cxClearCallRecords(void);

#endif /* CXCallTraceImpl_h */
