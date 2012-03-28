//
//  Event.m
//  iDoit
//
//  Created by Keith Fernandes on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"
#import "Alarm.h"
#import "Note.h"
#import "Tags.h"


@implementation Event

@dynamic aTitle;
@dynamic aPriority;
@dynamic creationDate;
@dynamic creationDateDay;
@dynamic sectionIdentifier, primitiveSectionIdentifier;
@dynamic aDate, primitiveADate;
@dynamic aType;
@dynamic rAlarm;
@dynamic rTags;
@dynamic rNote;





#pragma mark Init Values for attributes

- (void) awakeFromInsert{
    [super awakeFromInsert];
    
    [self setValue:[NSDate date] forKey:@"creationDate"];
    
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];    
    
    NSDateComponents *timeComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[self creationDate]];    
    [timeComponents setYear:[timeComponents year]];
    [timeComponents setMonth:[timeComponents month]];
    [timeComponents setDay:[timeComponents day]];
    
    [self setValue:[gregorian dateFromComponents:timeComponents] forKey:@"creationDateDay"];

    
}


#pragma mark Transient Properties

- (NSString *) sectionIdentifier {
    //to create and cache the section identifier on demand. note to self: sectionInfo for the fetchedResultsController makes use of this sectionIdentifier
    
    [self willAccessValueForKey:@"sectionIdentifier"];
    NSString * tmp = [self primitiveSectionIdentifier];
    [self didAccessValueForKey:@"sectionIdentifier"];
    
    //kvo read notifications - used to maintain inverse relationships (?). each read access has to be wrapped in this willAccessValueForKey and didAccessValueForKey method pairs. in this case to get the value for tmp
    
    if (!tmp) {
        /*organizing sections by date, month and year.  
         the section identifier is a string representing the number (year * 1000000 + month * 1000 + date);
         this will always maintain chronological order regardless of month name
         */
        NSCalendar * calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit |NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[self aDate]];
        
        tmp = [NSString stringWithFormat:@"%d", ([components year] * 1000000) + ([components month] *1000) + [components day]];
        
        [self setPrimitiveSectionIdentifier:tmp];
    }
    
    return tmp;
    
}


#pragma mark Due Date setter

- (void) setADate:(NSDate *)aDate {
    //If the due date is changed, the section identifier becomes invalid
    [self willChangeValueForKey:@"aDate"];
    
    [self setPrimitiveADate:aDate];
    
    [self didChangeValueForKey:@"aDate"];
    
    [self setPrimitiveSectionIdentifier:nil];
}

#pragma mark Key Path Dependencies

+ (NSSet *) keyPathsForValuesAffectingSectionIdentifier {
    //if the value of dueDate changes, the section identifier may change as well
    
    return [NSSet setWithObject: @"aDate"];
    
}


@end
