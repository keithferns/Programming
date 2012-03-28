//
//  Memo.m
//  iDoit
//
//  Created by Keith Fernandes on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Memo.h"


@implementation Memo



- (void) awakeFromInsert{
    [super awakeFromInsert];
    
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];    
    [gregorian setLocale:[NSLocale currentLocale]];
    [gregorian setTimeZone:[NSTimeZone localTimeZone]];
    //FIXME: Better way of setting the current timezone as the default and not as xx hours from GMT
    
    NSDateComponents *timeComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];    
    [timeComponents setYear:[timeComponents year]];
    [timeComponents setMonth:[timeComponents month]];
    [timeComponents setDay:[timeComponents day]];
    NSDate *currentDate= [gregorian dateFromComponents:timeComponents];
    
    [self setValue:currentDate forKey:@"aDate"];

  
    
}


@end
