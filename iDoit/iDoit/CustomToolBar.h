//
//  CustomToolBar.h
//  iDoit
//
//  Created by Keith Fernandes on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomToolBar : UIToolbar {
    
    UIBarButtonItem *firstButton, *secondButton, *thirdButton, *fourthButton, *fifthButton;
    
}

@property (nonatomic, retain) UIBarButtonItem *firstButton,  *secondButton, *thirdButton, *fourthButton, *fifthButton;
@property (readonly) UIImage *flipperImageForDateNavigationItem;


- (void) changeToSchedulingButtons;
- (void) changeToEditingButtons;



@end
/*
- (void) toggleDateButton:(id)sender;
- (void) toggleStartButton:(id)sender;
- (void) toggleEndButton:(id)sender;
- (void) toggleRecurButton:(id)sender;
*/