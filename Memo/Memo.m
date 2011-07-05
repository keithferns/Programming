// 
//  Memo.m
//  Memo
//
//  Created by Keith Fernandes on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Memo.h"

#import "File.h"
#import "MemoText.h"

@implementation Memo 

@dynamic creationDate;
@dynamic location;
@dynamic isEditing;
@dynamic appendToFile;
@dynamic memoText;
@dynamic memoRE;

+ (id) insertNewMemo: (NSManagedObjectContext *)context{
	
	return [NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:context];
}


@end
