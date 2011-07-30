//
//  MemoText.h
//  miMemo
//
//  Created by Keith Fernandes on 7/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Appointment, Memo, ToDo;

@interface MemoText : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * noteType;
@property (nonatomic, retain) NSString * memoText;
@property (nonatomic, retain) Appointment * savedAppointment;
@property (nonatomic, retain) ToDo * savedTask;
@property (nonatomic, retain) Memo * savedMemo;

@end
