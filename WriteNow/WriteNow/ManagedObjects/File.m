//
//  File.m
//  WriteNow
//
//  Created by Keith Fernandes on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "File.h"
#import "Folder.h"
#import "Memo.h"
#import "Tag.h"


@implementation File
@dynamic content;
@dynamic name;
@dynamic tags;
@dynamic folder;
@dynamic memos;

- (void)addTagsObject:(Tag *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"tags" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"tags"] addObject:value];
    [self didChangeValueForKey:@"tags" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTagsObject:(Tag *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"tags" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"tags"] removeObject:value];
    [self didChangeValueForKey:@"tags" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTags:(NSSet *)value {    
    [self willChangeValueForKey:@"tags" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"tags"] unionSet:value];
    [self didChangeValueForKey:@"tags" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTags:(NSSet *)value {
    [self willChangeValueForKey:@"tags" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"tags"] minusSet:value];
    [self didChangeValueForKey:@"tags" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



- (void)addMemosObject:(Memo *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"memos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"memos"] addObject:value];
    [self didChangeValueForKey:@"memos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeMemosObject:(Memo *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"memos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"memos"] removeObject:value];
    [self didChangeValueForKey:@"memos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addMemos:(NSSet *)value {    
    [self willChangeValueForKey:@"memos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"memos"] unionSet:value];
    [self didChangeValueForKey:@"memos" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeMemos:(NSSet *)value {
    [self willChangeValueForKey:@"memos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"memos"] minusSet:value];
    [self didChangeValueForKey:@"memos" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
