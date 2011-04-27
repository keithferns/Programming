//
//  SaveFileViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SaveFileViewController : UIViewController {

	UISegmentedControl *segmentedControl;
		
}

@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentedControlAction:(id)sender;

@end
