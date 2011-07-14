//
//  Appointment.h
//  Memo
//
//  Created by Keith Fernandes on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MemoText;

@interface Appointment :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * appointmentTime;
@property (nonatomic, retain) NSString * AppointmentRE;
@property (nonatomic, retain) MemoText * memoText;

+ (id) insertNewAppointment: (NSManagedObjectContext *)context;


@end



