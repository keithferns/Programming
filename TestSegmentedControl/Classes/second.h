//
//  second.h
//  TestSegmentedControl
//
//  Created by Keith Fernandes on 4/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface second : UIViewController {
	UILabel *segmentLabel;
	UISegmentedControl *segmentedControl;
	
}

@property (nonatomic,retain) IBOutlet UILabel *segmentLabel;
@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;

-(IBAction) segmentedControlIndexChanged;

@end


