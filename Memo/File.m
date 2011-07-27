//
//  File.m
//  Memo
//
//  Created by Keith Fernandes on 7/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "File.h"
#import "Folder.h"
#import "Memo.h"
#import "Tag.h"


@implementation File
@dynamic fileName;
@dynamic fileKeyWord;
@dynamic fileTag;
@dynamic appendMemo;
@dynamic savedIn;

- (void)addFileTagObject:(Tag *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"fileTag" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"fileTag"] addObject:value];
    [self didChangeValueForKey:@"fileTag" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeFileTagObject:(Tag *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"fileTag" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"fileTag"] removeObject:value];
    [self didChangeValueForKey:@"fileTag" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addFileTag:(NSSet *)value {    
    [self willChangeValueForKey:@"fileTag" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"fileTag"] unionSet:value];
    [self didChangeValueForKey:@"fileTag" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeFileTag:(NSSet *)value {
    [self willChangeValueForKey:@"fileTag" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"fileTag"] minusSet:value];
    [self didChangeValueForKey:@"fileTag" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addAppendMemoObject:(Memo *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"appendMemo" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"appendMemo"] addObject:value];
    [self didChangeValueForKey:@"appendMemo" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAppendMemoObject:(Memo *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"appendMemo" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"appendMemo"] removeObject:value];
    [self didChangeValueForKey:@"appendMemo" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAppendMemo:(NSSet *)value {    
    [self willChangeValueForKey:@"appendMemo" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"appendMemo"] unionSet:value];
    [self didChangeValueForKey:@"appendMemo" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAppendMemo:(NSSet *)value {
    [self willChangeValueForKey:@"appendMemo" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"appendMemo"] minusSet:value];
    [self didChangeValueForKey:@"appendMemo" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



@end
