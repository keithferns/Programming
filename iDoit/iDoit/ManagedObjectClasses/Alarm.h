//
//  Alarm.h
//  iDoit
//
//  Created by Keith Fernandes on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Alarm : NSManagedObject

@property (nonatomic, retain) NSDate * aReminder;
@property (nonatomic, retain) Event *rEvent;

@end
