//
//  Task.h
//  WriteNow
//
//  Created by Keith Fernandes on 9/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Note.h"


@interface Task : Note {
@private
}
@property (nonatomic, retain) NSString * recurring;
@property (nonatomic, retain) NSDate * doDate;
@property (nonatomic, retain) NSNumber * isRecurring;
@property (nonatomic, retain) NSDecimalNumber * priority;

@end
