//
//  File.h
//  NOW!!
//
//  Created by Keith Fernandes on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Memo.h"

@class Folder;

@interface File :  Memo  
{
}

@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSNumber * folderID;
@property (nonatomic, retain) NSSet* savedIn;

@end


@interface File (CoreDataGeneratedAccessors)
- (void)addSavedInObject:(Folder *)value;
- (void)removeSavedInObject:(Folder *)value;
- (void)addSavedIn:(NSSet *)value;
- (void)removeSavedIn:(NSSet *)value;

@end

