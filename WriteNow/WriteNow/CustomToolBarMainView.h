//
//  CustomToolBarMainView.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomToolBarMainView : UIToolbar {
 
     UIBarButtonItem *firstButton, *secondButton, *thirdButton, *fourthButton, *dismissKeyboard;
    
}


@property (nonatomic, retain) UIBarButtonItem *firstButton,  *secondButton, *thirdButton, *fourthButton, *dismissKeyboard;

- (void) toggleSaveAndSetDate;
- (void) toggleSetDateAndSetStart;
- (void) toggleSetStartAndSetEnd;
@end
