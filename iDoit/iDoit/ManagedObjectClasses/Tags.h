//
//  Tags.h
//  iDoit
//
//  Created by Keith Fernandes on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Document, Event, Folder, Note;

@interface Tags : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *files;
@property (nonatomic, retain) NSSet *notes;
@property (nonatomic, retain) NSSet *folders;
@property (nonatomic, retain) Event *events;
@end

@interface Tags (CoreDataGeneratedAccessors)

- (void)addFilesObject:(Document *)value;
- (void)removeFilesObject:(Document *)value;
- (void)addFiles:(NSSet *)values;
- (void)removeFiles:(NSSet *)values;
- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;
- (void)addFoldersObject:(Folder *)value;
- (void)removeFoldersObject:(Folder *)value;
- (void)addFolders:(NSSet *)values;
- (void)removeFolders:(NSSet *)values;
@end
