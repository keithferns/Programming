//
//  MyMemosViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/20/11.
//

#import <UIKit/UIKit.h>
#import "MyMemosTableViewController.h"

@interface MyMemosViewController : UIViewController {

	UISegmentedControl *segmentedControl;
		//MyMemosTableViewController *controller;	
}


	//@property (nonatomic, retain) IBOutlet MyMemosTableViewController *controller;
@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentedControlAction:(id)sender;


@end
