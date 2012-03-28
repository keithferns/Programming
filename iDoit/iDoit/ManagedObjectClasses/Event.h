//
//  Event.h
//  iDoit
//
//  Created by Keith Fernandes on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Alarm, Note, Tags;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * aTitle;
@property (nonatomic, retain) NSNumber * aPriority;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * creationDateDay;
@property (nonatomic, retain) NSString * sectionIdentifier, *primitiveSectionIdentifier;
@property (nonatomic, retain) NSDate * aDate, *primitiveADate;
@property (nonatomic, retain) NSNumber * aType;
@property (nonatomic, retain) NSSet *rAlarm;
@property (nonatomic, retain) Tags *rTags;
@property (nonatomic, retain) NSSet *rNote;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addRAlarmObject:(Alarm *)value;
- (void)removeRAlarmObject:(Alarm *)value;
- (void)addRAlarm:(NSSet *)values;
- (void)removeRAlarm:(NSSet *)values;
- (void)addRNoteObject:(Note *)value;
- (void)removeRNoteObject:(Note *)value;
- (void)addRNote:(NSSet *)values;
- (void)removeRNote:(NSSet *)values;
@end
