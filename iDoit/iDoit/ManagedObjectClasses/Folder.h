//
//  Folder.h
//  iDoit
//
//  Created by Keith Fernandes on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Document, Note, Tags;

@interface Folder : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * editDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) NSSet *documents;
@property (nonatomic, retain) NSSet *notes;
@end

@interface Folder (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tags *)value;
- (void)removeTagsObject:(Tags *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;
- (void)addDocumentsObject:(Document *)value;
- (void)removeDocumentsObject:(Document *)value;
- (void)addDocuments:(NSSet *)values;
- (void)removeDocuments:(NSSet *)values;
- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;
@end
