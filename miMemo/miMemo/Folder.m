//
//  Folder.m
//  miMemo
//
//  Created by Keith Fernandes on 7/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Folder.h"
#import "File.h"
#import "Memo.h"
#import "Tag.h"


@implementation Folder
@dynamic folderKeyWord;
@dynamic folderName;
@dynamic creationDate;
@dynamic containsFile;
@dynamic folderTag;
@dynamic containsMemo;

- (void)addContainsFileObject:(File *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"containsFile" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"containsFile"] addObject:value];
    [self didChangeValueForKey:@"containsFile" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeContainsFileObject:(File *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"containsFile" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"containsFile"] removeObject:value];
    [self didChangeValueForKey:@"containsFile" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addContainsFile:(NSSet *)value {    
    [self willChangeValueForKey:@"containsFile" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"containsFile"] unionSet:value];
    [self didChangeValueForKey:@"containsFile" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeContainsFile:(NSSet *)value {
    [self willChangeValueForKey:@"containsFile" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"containsFile"] minusSet:value];
    [self didChangeValueForKey:@"containsFile" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addFolderTagObject:(Tag *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"folderTag" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"folderTag"] addObject:value];
    [self didChangeValueForKey:@"folderTag" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeFolderTagObject:(Tag *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"folderTag" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"folderTag"] removeObject:value];
    [self didChangeValueForKey:@"folderTag" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addFolderTag:(NSSet *)value {    
    [self willChangeValueForKey:@"folderTag" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"folderTag"] unionSet:value];
    [self didChangeValueForKey:@"folderTag" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeFolderTag:(NSSet *)value {
    [self willChangeValueForKey:@"folderTag" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"folderTag"] minusSet:value];
    [self didChangeValueForKey:@"folderTag" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addContainsMemoObject:(Memo *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"containsMemo" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"containsMemo"] addObject:value];
    [self didChangeValueForKey:@"containsMemo" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeContainsMemoObject:(Memo *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"containsMemo" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"containsMemo"] removeObject:value];
    [self didChangeValueForKey:@"containsMemo" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addContainsMemo:(NSSet *)value {    
    [self willChangeValueForKey:@"containsMemo" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"containsMemo"] unionSet:value];
    [self didChangeValueForKey:@"containsMemo" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeContainsMemo:(NSSet *)value {
    [self willChangeValueForKey:@"containsMemo" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"containsMemo"] minusSet:value];
    [self didChangeValueForKey:@"containsMemo" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
