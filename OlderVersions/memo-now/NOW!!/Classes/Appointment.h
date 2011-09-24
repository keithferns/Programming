//
//  Appointment.h
//  NOW!!
//
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Memo.h"


@interface Appointment :  Memo  
{
}

@property (nonatomic, retain) NSDate * apptTime;
@property (nonatomic, retain) NSNumber * isRecurring;

@end



