//
//  File.h
//  Memo
//
//  Created by Keith Fernandes on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Folder;
@class Memo;

@interface File :  NSManagedObject  
{
    
}

@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSString * fileKeyWord;
@property (nonatomic, retain) NSString * fileTags;
@property (nonatomic, retain) NSSet* appendMemo;
@property (nonatomic, retain) Folder * savedIn;

@end


@interface File (CoreDataGeneratedAccessors)
- (void)addAppendMemoObject:(Memo *)value;
- (void)removeAppendMemoObject:(Memo *)value;
- (void)addAppendMemo:(NSSet *)value;
- (void)removeAppendMemo:(NSSet *)value;

@end

