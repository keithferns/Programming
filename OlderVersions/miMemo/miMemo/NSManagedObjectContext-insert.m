//
//  NSManagedObjectContext-insert.m
//  Memo
//
//  Created by Keith Fernandes on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObjectContext-insert.h"


@implementation NSManagedObjectContext (insert)

- (id) insertNewObjectForEntityForName:(NSString *) name{
	
	return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
}

@end
