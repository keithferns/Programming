//
//  Appointment.h
//  WriteNow
//
//  Created by Keith Fernandes on 9/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Note.h"


@interface Appointment : Note {
@private
}
@property (nonatomic, retain) NSDate * doTime;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSNumber * isRecurring;
@property (nonatomic, retain) NSDate * doDate;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * recurring;

@end
