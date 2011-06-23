//
//  File.h
//  NOW!!
//
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Folder;
@class Memo;

@interface File :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSSet* savedIn;
@property (nonatomic, retain) NSSet* appended;

@end


@interface File (CoreDataGeneratedAccessors)
- (void)addSavedInObject:(Folder *)value;
- (void)removeSavedInObject:(Folder *)value;
- (void)addSavedIn:(NSSet *)value;
- (void)removeSavedIn:(NSSet *)value;

- (void)addAppendedObject:(Memo *)value;
- (void)removeAppendedObject:(Memo *)value;
- (void)addAppended:(NSSet *)value;
- (void)removeAppended:(NSSet *)value;

@end

