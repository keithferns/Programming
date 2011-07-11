//
//  AppointmentsViewController.h
//  Memo
//
//  Created by Keith Fernandes on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppointmentsViewController : UIViewController {

	UILabel *viewLabel, *datetimeLabel;
	UIView *bottomview, *monthView, *datetimeView;
	BOOL swappingViews;
}


@property (nonatomic, retain) IBOutlet UILabel *viewLabel, *datetimeLabel;

@property (nonatomic, retain) IBOutlet UIView *bottomview, *monthView, *datetimeView;

- (void) swapViews;

- (IBAction) backAction;

- (IBAction)monthAction:(id)sender;



@end
