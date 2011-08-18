//
//  RootViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewController : UIViewController<UITextViewDelegate> {
 
    NSManagedObjectContext *managedObjectContext;
    UIView *containerView;

}

@property (nonatomic, retain) UITextView *textView;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UIToolbar *myToolBar;

@property (nonatomic, retain) NSString *previousTextInput;

- (void) addNewFolder;

- (void) addNewMemo;
- (void) addNewAppointment;
- (void) addNewTask;

@end
