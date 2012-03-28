//
//  UINavigationController+NavControllerCategory.h
//  iDoit
//
//  Created by Keith Fernandes on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (NavControllerCategory)


- (UIBarButtonItem *) addEditButton;
- (UIBarButtonItem *) addDoneButton;
- (UIBarButtonItem *) addOrganizeButton;
- (UIBarButtonItem *) addAddButton;
- (UIBarButtonItem *) addCancelButton;
- (UIBarButtonItem *) addListButton;
- (UIBarButtonItem *) addLeftArrowButton;
- (UIBarButtonItem *) addRightArrowButton;

//- (UIBarButtonItem *) addDateButton;
@end

