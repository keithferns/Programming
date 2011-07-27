//
//  Folder.m
//  Memo
//
//  Created by Keith Fernandes on 7/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Folder.h"
#import "File.h"
#import "Tag.h"


@implementation Folder
@dynamic folderKeyWord;
@dynamic folderName;
@dynamic folderTag;
@dynamic contains;

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


- (void)addContainsObject:(File *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"contains" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"contains"] addObject:value];
    [self didChangeValueForKey:@"contains" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeContainsObject:(File *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"contains" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"contains"] removeObject:value];
    [self didChangeValueForKey:@"contains" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addContains:(NSSet *)value {    
    [self willChangeValueForKey:@"contains" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"contains"] unionSet:value];
    [self didChangeValueForKey:@"contains" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeContains:(NSSet *)value {
    [self willChangeValueForKey:@"contains" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"contains"] minusSet:value];
    [self didChangeValueForKey:@"contains" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
