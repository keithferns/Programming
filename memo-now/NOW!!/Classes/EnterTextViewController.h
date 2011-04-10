//
//  EnterTextViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EnterTextViewController : UIViewController {

	UIButton *savememoButton, *gotowallButton, *newmemoButton;
	UILabel *memotitleLabel;
	UITextView *editmemopTextView;
}

@property (nonatomic, retain) IBOutlet UIButton *savememoButton, *gotowallButton, *newmemoButton;
@property (nonatomic, retain) IBOutlet UILabel *memotitleLabel; 
@property (nonatomic, retain) IBOutlet UITextView *editmemoTextView;

- (IBAction)savememoAction:(id)sender;
- (IBAction)gotowallAction:(id)sender;
- (IBAction)newmemoAction:(id)sender;


@end
