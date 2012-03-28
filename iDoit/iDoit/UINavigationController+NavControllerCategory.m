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
    
    UIBarButtonItem *editButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:nil action:@selector(editTextView:)]autorelease];
 
    return editButton;
}

- (UIBarButtonItem *) addDoneButton {
    
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil
   action:nil] autorelease];
    
    return doneButton;
}

- (UIBarButtonItem *) addOrganizeButton {
    UIBarButtonItem *organizeButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:nil action:nil]autorelease];
    
    return organizeButton;
}


- (UIBarButtonItem *) addAddButton {
    
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:@selector(startNewItem:)] autorelease];
    
    return addButton;
}


- (UIBarButtonItem *) addCancelButton {
    
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:@selector(toggleTextAndScheduleView:)] autorelease];
    
    return cancelButton;
    
}

- (UIBarButtonItem *) addListButton{
    
    UIImage *image = [UIImage imageNamed:@"list_nav.png"];
    
    UIButton *temp = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    temp.layer.cornerRadius = 6.0;
    temp.layer.borderWidth = 1.0;
    //temp.clipsToBounds = YES;
    
    [temp setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *listButton = [[[UIBarButtonItem alloc] initWithCustomView:temp] autorelease];
    [temp release];
    return listButton;
}

- (UIBarButtonItem *) addLeftArrowButton{
    
    UIImage *image = [UIImage imageNamed:@"arrow_left_24.png"];
    
    
    UIBarButtonItem *leftArrowButton = [[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleBordered target:nil action:@selector(postSelectedDateNotification:)]autorelease];

    return leftArrowButton;
}

- (UIBarButtonItem *) addRightArrowButton{
    
    UIImage *image = [UIImage imageNamed:@"arrow_right_24.png"];
    
    UIBarButtonItem *rightArrowButton = [[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleBordered target:nil action:@selector(postSelectedDateNotification:)]autorelease];
    
    return rightArrowButton;
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
