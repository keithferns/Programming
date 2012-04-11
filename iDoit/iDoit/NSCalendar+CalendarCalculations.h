//
//  NSCalendar+CalendarCalculations.h
//  iDoit
//
//  Created by Keith Fernandes on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (CalendarCalculations)

-(NSInteger)daysWithinEraFromDate:(NSDate *) startDate toDate:(NSDate *) endDate;
@end
