// 
//  Memo.m
//  NOW!!
//
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Memo.h"

#import "File.h"

@implementation Memo 

@dynamic isEditing;
@dynamic timeStamp;
@dynamic memoText;
@dynamic appendTo;


+ (id) insertNewMemo: (NSManagedObjectContext *)context{
	
	return [NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:context];

}

@end
