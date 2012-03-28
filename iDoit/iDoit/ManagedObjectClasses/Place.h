//
//  Place.h
//  iDoit
//
//  Created by Keith Fernandes on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Appointment, Note;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *notes;
@property (nonatomic, retain) Appointment *appointment;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;
@end
