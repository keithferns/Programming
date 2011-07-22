//
//  ToDo.h
//  Memo
//
//  Created by Keith Fernandes on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MemoText;

@interface ToDo :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * doDate;
@property (nonatomic, retain) NSNumber * isRecurring;
@property (nonatomic, retain) MemoText * memoText;

@end



