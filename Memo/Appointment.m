// 
//  Appointment.m
//  Memo
//
//  Created by Keith Fernandes on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Appointment.h"

#import "MemoText.h"

@implementation Appointment 

@dynamic creationDate;
@dynamic appointmentTime;
@dynamic appointmentRE;
@dynamic memoText;


+ (id) insertNewAppointment: (NSManagedObjectContext *)context{
	
	return [NSEntityDescription insertNewObjectForEntityForName:@"Appointment" inManagedObjectContext:context];
}


@end
