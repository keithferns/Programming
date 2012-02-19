//
//  ArchiveViewController.h
//  iDoit
//
//  Created by Keith Fernandes on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WEPopoverController.h"

@interface ArchiveViewController : UIViewController <PopoverControllerDelegate>{
}

@property (nonatomic, retain) WEPopoverController *actionsPopover;
@property (nonatomic, assign) BOOL isSaving; 

- (UIView *) addItemsView: (CGRect) frame;

- (UIView *)organizerView: (CGRect)frame;
- (void) presentActionsPopover:(id) sender;

@end


