//
//  CustomToolBar.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomToolBar : UIToolbar {
    UIBarButtonItem *firstButton, *secondButton, *thirdButton, *fourthButton, *dismissKeyboard;

}

@property (nonatomic, retain) UIBarButtonItem *firstButton, *secondButton, *thirdButton, *fourthButton, *dismissKeyboard;
  

@end
