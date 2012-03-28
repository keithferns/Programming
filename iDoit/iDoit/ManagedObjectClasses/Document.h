//
//  Document.h
//  iDoit
//
//  Created by Keith Fernandes on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"

@class Folder, Tags;

@interface Document : Event

@property (nonatomic, retain) NSString * aText;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) Folder *folder;
@end

@interface Document (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tags *)value;
- (void)removeTagsObject:(Tags *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;
@end
