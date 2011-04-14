//
//  SaveMemoViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavButton.h"

@interface SaveMemoViewController : UIViewController {

		NavButton *backButton;
		NavButton *newButton;
		NavButton *wallButton;
	
		//FIX:  reusing some of the buttons.  make separate classes for each. 

}

@property(nonatomic, retain) IBOutlet NavButton *backButton;
@property(nonatomic, retain) IBOutlet NavButton *newButton;
@property(nonatomic, retain) IBOutlet NavButton *wallButton;


- (IBAction)backAction:(id)sender;
- (IBAction)newAction:(id)sender;



@end
