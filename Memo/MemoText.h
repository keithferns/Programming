//
//  MemoText.h
//  Memo
//
//  Created by Keith Fernandes on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface MemoText :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * memoText;

+ (id) insertNewMemoText: (NSManagedObjectContext *)context;

@end



