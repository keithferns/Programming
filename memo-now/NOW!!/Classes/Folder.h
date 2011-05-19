//
//  Folder.h
//  NOW!!
//
//  Created by Keith Fernandes on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Folder :  NSManagedObject  
{
	
}

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * folderTags;
@property (nonatomic, retain) NSNumber * folderID;
@property (nonatomic, retain) NSString * folderName;
@property (nonatomic, retain) NSString * folderKeyWords;
@property (nonatomic, retain) NSSet* contains;

@end


@interface Folder (CoreDataGeneratedAccessors)
- (void)addContainsObject:(NSManagedObject *)value;
- (void)removeContainsObject:(NSManagedObject *)value;
- (void)addContains:(NSSet *)value;
- (void)removeContains:(NSSet *)value;

@end

