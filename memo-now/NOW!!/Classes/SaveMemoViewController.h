//
//  SaveMemoViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SaveMemoViewController : UIViewController {

UIButton *backButton;
	
//FIX:  reusing some of the buttons.  make separate classes for each. 

}

@property(nonatomic, retain) IBOutlet UIButton *backButton;

- (IBAction)backAction:(id)sender;


@end
