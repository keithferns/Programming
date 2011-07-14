//
//  File.h
//  Memo
//
//  Created by Keith Fernandes on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Memo;

@interface File :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* appendMemo;

@end


@interface File (CoreDataGeneratedAccessors)
- (void)addAppendMemoObject:(Memo *)value;
- (void)removeAppendMemoObject:(Memo *)value;
- (void)addAppendMemo:(NSSet *)value;
- (void)removeAppendMemo:(NSSet *)value;

@end
/* Factory methods for entities.
 //Appointment
 + (id) insertNewAppointment: (NSManagedObjectContext *)context;

 + (id) insertNewAppointment: (NSManagedObjectContext *)context{
 
 return [NSEntityDescription insertNewObjectForEntityForName:@"Appointment" inManagedObjectContext:context];
 }
 
 //MemoText
 
 + (id) insertNewMemoText: (NSManagedObjectContext *)context;
 + (id) insertNewMemoText: (NSManagedObjectContext *)context{
 
 return [NSEntityDescription insertNewObjectForEntityForName:@"MemoText" inManagedObjectContext:context];
 }
 //Memo
 + (id) insertNewMemo: (NSManagedObjectContext *)context;

 
 + (id) insertNewMemo: (NSManagedObjectContext *)context{
 
 return [NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:context];
 }
 
 
 */

