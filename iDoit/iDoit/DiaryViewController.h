//
//  DiaryViewController.h
//  iDoit
//
//  Created by Keith Fernandes on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKCalendarMonthView.h"


@interface DiaryViewController : UIViewController<TKCalendarMonthViewDelegate>{
    NSInteger dateCounter;
}

@property NSInteger dateCounter;
@property (nonatomic, retain) TKCalendarMonthView *calendarView;
@property (nonatomic, retain) UILabel *datelabel;

//@property (nonatomic, strong)  UIScrollView *scrollView;
//@property (nonatomic, strong)  UIPageControl *pageControl;

- (void) postSelectedDateNotification:(id) sender;

@end
