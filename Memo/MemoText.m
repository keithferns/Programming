// 
//  MemoText.m
//  Memo
//
//  Created by Keith Fernandes on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MemoText.h"


@implementation MemoText 

@dynamic memoText;
@dynamic noteType;

+ (id) insertNewMemoText: (NSManagedObjectContext *)context{
	
	return [NSEntityDescription insertNewObjectForEntityForName:@"MemoText" inManagedObjectContext:context];
}



@end
