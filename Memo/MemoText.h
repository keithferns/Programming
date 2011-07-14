//
//  MemoText.h
//  Memo
//
//  Created by Keith Fernandes on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface MemoText :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * memoText;
@property (nonatomic, retain) NSNumber * noteType;

+ (id) insertNewMemoText: (NSManagedObjectContext *)context;


@end



