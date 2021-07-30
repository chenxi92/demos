//
//  CXFloatDeviceUtils.m
//  FloatWindowDemo
//
//  Created by peak on 2020/9/21.
//  Copyright © 2020 peak. All rights reserved.
//

#import "CXFloatDeviceUtils.h"
#import <mach/mach.h>

uint64_t CXResidentMemoryInBytes(void)
{
    kern_return_t rval = 0;
    mach_port_t task = mach_task_self();
    
    struct task_basic_info info = {0};
    mach_msg_type_number_t tcnt = TASK_BASIC_INFO_COUNT;
    task_flavor_t flavor = TASK_BASIC_INFO;
    
    task_info_t tptr = (task_info_t)&info;
    if (tcnt > sizeof(info)) {
        return 0;
    }
    
    rval = task_info(task, flavor, tptr, &tcnt);
    if (rval != KERN_SUCCESS) {
        return 0;
    }
    
    return info.resident_size;
}
