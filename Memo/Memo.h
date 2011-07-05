//
//  Memo.h
//  Memo
//
//  Created by Keith Fernandes on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class File;
@class MemoText;

@interface Memo :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * isEditing;
@property (nonatomic, retain) File * appendToFile;
@property (nonatomic, retain) MemoText * memoText;
@property (nonatomic, retain) NSString * memoRE;

+ (id) insertNewMemo: (NSManagedObjectContext *)context;


@end



