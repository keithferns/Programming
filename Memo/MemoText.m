// 
//  MemoText.m
//  Memo
//
//  Created by Keith Fernandes on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MemoText.h"


@implementation MemoText 

@dynamic memoText;

+ (id) insertNewMemoText: (NSManagedObjectContext *)context{
	
	return [NSEntityDescription insertNewObjectForEntityForName:@"MemoText" inManagedObjectContext:context];
}


@end
