//
//  Folder.h
//  Memo
//
//  Created by Keith Fernandes on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class File;

@interface Folder :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * folderTags;
@property (nonatomic, retain) NSString * folderName;
@property (nonatomic, retain) NSString * folderKeyWord;
@property (nonatomic, retain) NSSet* contains;

@end


@interface Folder (CoreDataGeneratedAccessors)
- (void)addContainsObject:(File *)value;
- (void)removeContainsObject:(File *)value;
- (void)addContains:(NSSet *)value;
- (void)removeContains:(NSSet *)value;

@end

