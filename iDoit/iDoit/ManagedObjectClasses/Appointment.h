//
//  Appointment.h
//  iDoit
//
//  Created by Keith Fernandes on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"

@class Person, Place;

@interface Appointment : Event

@property (nonatomic, retain) NSDate * aStartTime;
@property (nonatomic, retain) NSDate * aEndTime;
@property (nonatomic, retain) NSString * aAppointmentType;
@property (nonatomic, retain) Place *rPlace;
@property (nonatomic, retain) Person *rPerson;

@end
