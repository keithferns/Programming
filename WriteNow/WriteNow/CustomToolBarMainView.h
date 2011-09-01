//
//  CustomToolBarMainView.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomToolBarMainView : UIToolbar {
 
     UIBarButtonItem *actionButton, *dismissKeyboard, *memoButton, *appointmentButton, *taskButton;
    
}


@property (nonatomic, retain) UIBarButtonItem *actionButton, *dismissKeyboard, *memoButton, *appointmentButton, *taskButton;

@end
