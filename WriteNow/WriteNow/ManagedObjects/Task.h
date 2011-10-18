//
//  Task.h
//  WriteNow
//
//  Created by Keith Fernandes on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Note.h"

@class Alarm;

@interface Task : Note {
@private
}
@property (nonatomic, retain) NSString * recurring;
@property (nonatomic, retain) NSNumber * isRecurring;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSString * taskType;
@property (nonatomic, retain) NSSet* alarm;

@end
