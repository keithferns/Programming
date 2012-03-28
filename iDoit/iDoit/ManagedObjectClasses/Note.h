//
//  Note.h
//  iDoit
//
//  Created by Keith Fernandes on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Folder, Place, Tags;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSDate * editDate;
@property (nonatomic, retain) NSNumber * isEditing;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Place *location;
@property (nonatomic, retain) Folder *folder;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) NSSet *rEvent;
@end

@interface Note (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tags *)value;
- (void)removeTagsObject:(Tags *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;
- (void)addREventObject:(Event *)value;
- (void)removeREventObject:(Event *)value;
- (void)addREvent:(NSSet *)values;
- (void)removeREvent:(NSSet *)values;
@end
