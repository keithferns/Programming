//
//  ToDo.h
//  NOW!!
//
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Memo.h"


@interface ToDo :  Memo  
{
}

@property (nonatomic, retain) NSNumber * isRecurring;
@property (nonatomic, retain) NSDate * dueDate;

@end



