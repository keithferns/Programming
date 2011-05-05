//
//  DateTimeViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DateTimeViewController : UIViewController {
	
		//int appDay, appMonth, appTime;
	UISegmentedControl *segmentedControl;
	UIButton *m1, *m2, *m3, *m4, *m5, *m6, *m7, *m8, *m9, *m10, *m11, *m12, *d1, *d2, *d3, *d4, *d5, *d6, *d7, *d8, *d9, *d0, *backslash, *timeButton;
	UILabel *monthLabel, *dateLabel;
	
}

@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UILabel *monthLabel, *dateLabel;
@property (nonatomic, retain) IBOutlet UIButton *m1, *m2, *m3, *m4, *m5, *m6, *m7, *m8, *m9, *m10, *m11, *m12, *d1, *d2, *d3, *d4, *d5, *d6, *d7, *d8, *d9, *d0, *backslash, *timeButton;



- (IBAction)segmentedControlAction:(id)sender;

- (IBAction)monthAction:(id)sender;


- (IBAction)dayAction:(id)sender;






@end
