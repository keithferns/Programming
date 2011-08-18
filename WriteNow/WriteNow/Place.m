//
//  Place.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Place.h"
#import "Note.h"
#import "Person.h"


@implementation Place
@dynamic Address;
@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic notes;
@dynamic persons;

- (void)addNotesObject:(Note *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"notes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"notes"] addObject:value];
    [self didChangeValueForKey:@"notes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeNotesObject:(Note *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"notes" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"notes"] removeObject:value];
    [self didChangeValueForKey:@"notes" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addNotes:(NSSet *)value {    
    [self willChangeValueForKey:@"notes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"notes"] unionSet:value];
    [self didChangeValueForKey:@"notes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeNotes:(NSSet *)value {
    [self willChangeValueForKey:@"notes" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"notes"] minusSet:value];
    [self didChangeValueForKey:@"notes" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addPersonsObject:(Person *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"persons" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"persons"] addObject:value];
    [self didChangeValueForKey:@"persons" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removePersonsObject:(Person *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"persons" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"persons"] removeObject:value];
    [self didChangeValueForKey:@"persons" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addPersons:(NSSet *)value {    
    [self willChangeValueForKey:@"persons" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"persons"] unionSet:value];
    [self didChangeValueForKey:@"persons" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removePersons:(NSSet *)value {
    [self willChangeValueForKey:@"persons" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"persons"] minusSet:value];
    [self didChangeValueForKey:@"persons" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
