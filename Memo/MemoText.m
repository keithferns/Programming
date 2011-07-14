// 
//  MemoText.m
//  Memo
//
//  Created by Keith Fernandes on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MemoText.h"

#import "Appointment.h"
#import "Memo.h"

@implementation MemoText 

@dynamic noteType;
@dynamic memoText;
@dynamic savedAppointment;
@dynamic savedMemo;

+ (id) insertNewMemoText: (NSManagedObjectContext *)context{
	
	return [NSEntityDescription insertNewObjectForEntityForName:@"MemoText" inManagedObjectContext:context];
}




@end
