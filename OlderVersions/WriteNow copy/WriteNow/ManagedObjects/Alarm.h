//
//  Alarm.h
//  WriteNow
//
//  Created by Keith Fernandes on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Appointment, Task;

@interface Alarm : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * reminder;
@property (nonatomic, retain) Task * task;
@property (nonatomic, retain) Appointment * appointment;

@end
