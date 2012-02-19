//
//  UINavigationController+NavControllerCategory.m
//  iDoit
//
//  Created by Keith Fernandes on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UINavigationController+NavControllerCategory.h"

@implementation UINavigationController (NavControllerCategory)


- (UIBarButtonItem *) addEditButton {
    
    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:nil action:@selector(editTextView:)] autorelease];
 
    return editButton;
}

- (UIBarButtonItem *) addDoneButton {
    
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil
   action:@selector(toggleTextAndScheduleView:)] autorelease];
    
    return doneButton;
}

- (UIBarButtonItem *) addOrganizeButton {
    UIBarButtonItem *organizeButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:nil action:nil] autorelease];
    
    return organizeButton;
}


- (UIBarButtonItem *) addAddButton {
    
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil] autorelease];
    
    return addButton;
}


- (UIBarButtonItem *) addCancelButton {
    
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:@selector(toggleTextAndScheduleView:)] autorelease];
    
    return cancelButton;
    
}
/*
- (UIBarButtonItem *) addCustomCancelButton{
    //Add Cancel Button to the Nav Bar. Set it to call method to toggle text/shedule view
    UIImage *leftImage = [UIImage imageNamed:@"cancel_clear_white_on_blue_button.png"];
    UIButton *leftNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftNavButton setImage:leftImage forState:UIControlStateNormal];
    [leftNavButton setImage:leftImage forState:UIControlStateHighlighted];
    leftNavButton.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
    [leftNavButton addTarget:nil action:@selector(toggleTextAndScheduleView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftNavButton];
    self.navigationItem.leftBarButtonItem  = leftButton;
    [leftButton release];

    
}

- (UIBarButtonItem *) addDateButton {
 UIImage *rightImage = [UIImage imageNamed:@"addDate.png"];
 UIButton *rightNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
 [rightNavButton setImage:rightImage forState:UIControlStateNormal];
 [rightNavButton setImage:rightImage forState:UIControlStateHighlighted];
 rightNavButton.frame = CGRectMake(0, 0, rightImage.size.width, rightImage.size.height);
    UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc] initWithCustomView:rightNavButton] autorelease];;

    return rightButton;
        
}
 
 */
@end
