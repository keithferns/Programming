//
//  DateTimeViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DateTimeViewController : UIViewController {
	
	UIButton *backslash, *timeButton;
	UILabel *topLabel, *bottomLabel;
	UIView *monthView, *dateView, *timeVIew, *priorityView;
	UISlider *prioritySlider;
}

@property (nonatomic, retain) IBOutlet UILabel *topLabel, *bottomLabel;
@property (nonatomic, retain) IBOutlet UIButton  *backslash, *timeButton;
@property (nonatomic, retain) IBOutlet UIView *monthView, *dateView, *timeView, *priorityView; 
@property (nonatomic, retain) IBOutlet UISlider *prioritySlider;



-(IBAction) navigationAction:(id)sender;

- (IBAction)monthAction:(id)sender;

- (IBAction)dayAction:(id)sender;

- (IBAction)timeButtonAction;

- (IBAction)timeAction:(id)sender;

- (IBAction)sliderValueChanged:(UISlider *)sender;

- (IBAction) doneAction;





@end
