//
//  MyWallViewController.h
//  NOW!!
//
//  Created by Keith Fernandes on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>  


@interface MyWallViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {

	
	
}

-(IBAction)showActionSheet:(id)sender;

-(IBAction)sendMail:(id)sender;

@end
