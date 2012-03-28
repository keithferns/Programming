//
//  Note.m
//  iDoit
//
//  Created by Keith Fernandes on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Note.h"
#import "Event.h"
#import "Folder.h"
#import "Place.h"
#import "Tags.h"


@implementation Note

@dynamic editDate;
@dynamic isEditing;
@dynamic creationDate;
@dynamic title;
@dynamic text;
@dynamic location;
@dynamic folder;
@dynamic tags;
@dynamic rEvent;


- (void) awakeFromInsert{
    [super awakeFromInsert];
    
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];    
    [gregorian setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *timeComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:[NSDate date]];    
    [timeComponents setYear:[timeComponents year]];
    [timeComponents setMonth:[timeComponents month]];
    [timeComponents setDay:[timeComponents day]];
    [timeComponents setHour:0];
    [timeComponents setMinute: 0];
    [timeComponents setSecond:0];
    
    
 [self setValue:[gregorian dateFromComponents:timeComponents] forKey:@"creationDate"];}

@end
