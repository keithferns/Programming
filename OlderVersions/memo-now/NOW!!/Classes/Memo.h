//
//  Memo.h
//  NOW!!
//
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class File;

@interface Memo :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * isEditing;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * memoText;
@property (nonatomic, retain) File * appendTo;

+ (id) insertNewMemo: (NSManagedObjectContext *)context;

@end



