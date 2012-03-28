//
//  ToDo.h
//  iDoit
//
//  Created by Keith Fernandes on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"


@interface ToDo : Event

@property (nonatomic, retain) NSNumber * isRecurring;
@property (nonatomic, retain) NSString * aRecurrence;
@property (nonatomic, retain) NSString * aToDoType;

@end
