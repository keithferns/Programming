//
//  MemoText.h
//  Memo
//
//  Created by Keith Fernandes on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Appointment;
@class Memo;
@class ToDo;

@interface MemoText :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * noteType;
@property (nonatomic, retain) NSString * memoText;
@property (nonatomic, retain) Appointment * savedAppointment;
@property (nonatomic, retain) ToDo * savedTask;
@property (nonatomic, retain) Memo * savedMemo;

@end



