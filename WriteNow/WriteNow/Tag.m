//
//  Tag.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Tag.h"
#import "File.h"
#import "Folder.h"
#import "Memo.h"


@implementation Tag
@dynamic name;
@dynamic folders;
@dynamic files;
@dynamic memos;

- (void)addFoldersObject:(Folder *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"folders" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"folders"] addObject:value];
    [self didChangeValueForKey:@"folders" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeFoldersObject:(Folder *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"folders" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"folders"] removeObject:value];
    [self didChangeValueForKey:@"folders" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addFolders:(NSSet *)value {    
    [self willChangeValueForKey:@"folders" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"folders"] unionSet:value];
    [self didChangeValueForKey:@"folders" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeFolders:(NSSet *)value {
    [self willChangeValueForKey:@"folders" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"folders"] minusSet:value];
    [self didChangeValueForKey:@"folders" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addFilesObject:(File *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"files" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"files"] addObject:value];
    [self didChangeValueForKey:@"files" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeFilesObject:(File *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"files" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"files"] removeObject:value];
    [self didChangeValueForKey:@"files" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addFiles:(NSSet *)value {    
    [self willChangeValueForKey:@"files" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"files"] unionSet:value];
    [self didChangeValueForKey:@"files" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeFiles:(NSSet *)value {
    [self willChangeValueForKey:@"files" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"files"] minusSet:value];
    [self didChangeValueForKey:@"files" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
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
