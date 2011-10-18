//
//  Appointment.m
//  WriteNow
//
//  Created by Keith Fernandes on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Appointment.h"
#import "Alarm.h"
#import "Place.h"


@implementation Appointment
@dynamic isRecurring;
@dynamic recurring;
@dynamic priority;
@dynamic appointmentType;
@dynamic place;
@dynamic alarm;


- (void)addAlarmObject:(Alarm *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"alarm" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"alarm"] addObject:value];
    [self didChangeValueForKey:@"alarm" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAlarmObject:(Alarm *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"alarm" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"alarm"] removeObject:value];
    [self didChangeValueForKey:@"alarm" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAlarm:(NSSet *)value {    
    [self willChangeValueForKey:@"alarm" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"alarm"] unionSet:value];
    [self didChangeValueForKey:@"alarm" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAlarm:(NSSet *)value {
    [self willChangeValueForKey:@"alarm" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"alarm"] minusSet:value];
    [self didChangeValueForKey:@"alarm" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
