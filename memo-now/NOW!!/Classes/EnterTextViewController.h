//
//  EnterTextViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EditTextView.h"
#import "NavButton.h"


@interface EnterTextViewController : UIViewController {

	NavButton *saveButton, *wallButton, *newButton;
		//	UILabel *memotitleLabel;
	EditTextView *editmemoTextView, *reeditmemoTextView;
}

@property (nonatomic, retain) IBOutlet NavButton *saveButton, *wallButton, *newButton;
	//@property (nonatomic, retain) IBOutlet UILabel *memotitleLabel; 
@property (nonatomic, retain) IBOutlet EditTextView *editmemoTextView, *reeditmemoTextView;

- (IBAction)savememoAction:(id)sender;
- (IBAction)gotowallAction:(id)sender;
- (IBAction)newmemoAction:(id)sender;
- (IBAction)movebottomTextView:(id)sender;


@end


