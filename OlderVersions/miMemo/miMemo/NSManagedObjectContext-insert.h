//
//  NSManagedObjectContext-insert.h
//  Memo
//
//  Created by Keith Fernandes on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface NSManagedObjectContext(insert)

- (id) insertNewObjectForEntityForName:(NSString *) name;



@end
