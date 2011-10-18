//
//  Appointment.h
//  WriteNow
//
//  Created by Keith Fernandes on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Note.h"

@class Alarm, Place;

@interface Appointment : Note {
@private
}
@property (nonatomic, retain) NSNumber * isRecurring;
@property (nonatomic, retain) NSString * recurring;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSString * appointmentType;
@property (nonatomic, retain) Place * place;
@property (nonatomic, retain) NSSet* alarm;

@end
