//
//  Memo.m
//  miMemo
//
//  Created by Keith Fernandes on 8/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Memo.h"
#import "File.h"
#import "Folder.h"
#import "MemoText.h"
#import "Tag.h"


@implementation Memo
@dynamic memoRE;
@dynamic doDate;
@dynamic location;
@dynamic isEditing;
@dynamic appendToFile;
@dynamic memoTag;
@dynamic memoText;
@dynamic savedIn;


- (void)addMemoTagObject:(Tag *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"memoTag" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"memoTag"] addObject:value];
    [self didChangeValueForKey:@"memoTag" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeMemoTagObject:(Tag *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"memoTag" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"memoTag"] removeObject:value];
    [self didChangeValueForKey:@"memoTag" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addMemoTag:(NSSet *)value {    
    [self willChangeValueForKey:@"memoTag" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"memoTag"] unionSet:value];
    [self didChangeValueForKey:@"memoTag" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeMemoTag:(NSSet *)value {
    [self willChangeValueForKey:@"memoTag" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"memoTag"] minusSet:value];
    [self didChangeValueForKey:@"memoTag" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}




@end
