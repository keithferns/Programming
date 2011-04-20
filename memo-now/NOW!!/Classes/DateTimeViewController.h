//
//  DateTimeViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DateTimeViewController : UIViewController {
	
	UISegmentedControl *segmentedControl;
	
	
}

@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentedControlAction:(id)sender;

	//- (IBAction)backAction:(id)sender;



@end
