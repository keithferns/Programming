//
//  Memo.h
//  Memo
//
//  Created by Keith Fernandes on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class File;
@class MemoText;

@interface Memo :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * memoRE;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * doDate;
@property (nonatomic, retain) NSNumber * isEditing;
@property (nonatomic, retain) File * appendToFile;
@property (nonatomic, retain) MemoText * memoText;

@end



