//
//  MyPlanner.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPlanner : UIViewController {
		
		UIButton *todayButton, *tomorrowButton, *somedayButton, *thisdayButton, *thisWeekButton, *nextWeekButton, *thisMonthButton, *thisYearButton;
	}


@property(nonatomic, retain) IBOutlet UIButton *todayButton, *tomorrowButton, *somedayButton, *thisdayButton, *thisWeekButton, *nextWeekButton, *thisMonthButton, *thisYearButton;
	

- (IBAction)todayAction:(id)sender;
- (IBAction)tomorrowAction:(id)sender;
- (IBAction)someDayAction:(id)sender;
- (IBAction)thisDayAction:(id)sender;
- (IBAction)thisWeekAction:(id)sender;
- (IBAction)nextweekAction:(id)sender;
- (IBAction)thisMonthAction:(id)sender;
- (IBAction)thisYearAction:(id)sender;

- (IBAction)navigationAction:(id)sender;


@end
