//
//  ToDo.h
//  NOW!!
//
//  Created by Keith Fernandes on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Memo.h"


@interface ToDo :  Memo  
{
}

@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * isRecurring;

@end



