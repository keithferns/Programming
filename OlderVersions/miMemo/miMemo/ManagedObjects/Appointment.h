//
//  Appointment.h
//  miMemo
//
//  Created by Keith Fernandes on 8/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MemoText;

@interface Appointment : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * appointmentRE;
@property (nonatomic, retain) NSNumber * isRecurring;
@property (nonatomic, retain) NSString * doDate;
@property (nonatomic, retain) NSDate * selectedDate;
@property (nonatomic, retain) NSString * doTime;
@property (nonatomic, retain) MemoText * memoText;

@end
