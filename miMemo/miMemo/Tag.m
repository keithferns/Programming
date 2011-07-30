//
//  Tag.m
//  miMemo
//
//  Created by Keith Fernandes on 7/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Tag.h"
#import "File.h"
#import "Folder.h"
#import "Memo.h"


@implementation Tag
@dynamic myTag;
@dynamic taggedFile;
@dynamic taggedFolder;
@dynamic taggedMemo;

- (void)addTaggedFileObject:(File *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"taggedFile" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"taggedFile"] addObject:value];
    [self didChangeValueForKey:@"taggedFile" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTaggedFileObject:(File *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"taggedFile" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"taggedFile"] removeObject:value];
    [self didChangeValueForKey:@"taggedFile" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTaggedFile:(NSSet *)value {    
    [self willChangeValueForKey:@"taggedFile" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"taggedFile"] unionSet:value];
    [self didChangeValueForKey:@"taggedFile" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTaggedFile:(NSSet *)value {
    [self willChangeValueForKey:@"taggedFile" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"taggedFile"] minusSet:value];
    [self didChangeValueForKey:@"taggedFile" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addTaggedFolderObject:(Folder *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"taggedFolder" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"taggedFolder"] addObject:value];
    [self didChangeValueForKey:@"taggedFolder" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTaggedFolderObject:(Folder *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"taggedFolder" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"taggedFolder"] removeObject:value];
    [self didChangeValueForKey:@"taggedFolder" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTaggedFolder:(NSSet *)value {    
    [self willChangeValueForKey:@"taggedFolder" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"taggedFolder"] unionSet:value];
    [self didChangeValueForKey:@"taggedFolder" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTaggedFolder:(NSSet *)value {
    [self willChangeValueForKey:@"taggedFolder" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"taggedFolder"] minusSet:value];
    [self didChangeValueForKey:@"taggedFolder" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addTaggedMemoObject:(Memo *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"taggedMemo" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"taggedMemo"] addObject:value];
    [self didChangeValueForKey:@"taggedMemo" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTaggedMemoObject:(Memo *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"taggedMemo" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"taggedMemo"] removeObject:value];
    [self didChangeValueForKey:@"taggedMemo" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTaggedMemo:(NSSet *)value {    
    [self willChangeValueForKey:@"taggedMemo" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"taggedMemo"] unionSet:value];
    [self didChangeValueForKey:@"taggedMemo" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTaggedMemo:(NSSet *)value {
    [self willChangeValueForKey:@"taggedMemo" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"taggedMemo"] minusSet:value];
    [self didChangeValueForKey:@"taggedMemo" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
