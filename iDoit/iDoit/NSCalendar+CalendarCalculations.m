//
//  NSCalendar+CalendarCalculations.m
//  iDoit
//
//  Created by Keith Fernandes on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSCalendar+CalendarCalculations.h"

@implementation NSCalendar (CalendarCalculations)


-(NSInteger)daysWithinEraFromDate:(NSDate *) startDate toDate:(NSDate *) endDate
{
NSInteger startDay=[self ordinalityOfUnit:NSDayCalendarUnit
                                   inUnit: NSEraCalendarUnit forDate:startDate];
NSInteger endDay=[self ordinalityOfUnit:NSDayCalendarUnit
                                 inUnit: NSEraCalendarUnit forDate:endDate];
return endDay-startDay;
}

//Determines whether a date falls in the current week
-(BOOL)isDateThisWeek:(NSDate *)date {
    NSDate *start;
    NSTimeInterval extends;
    NSDate *today=[NSDate date];
    BOOL success= [self rangeOfUnit:NSWeekCalendarUnit startDate:&start
                          interval: &extends forDate:today];
    if(!success)return NO;
    NSTimeInterval dateInSecs = [date timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    }
    else {
        return NO;
    }
}


@end


