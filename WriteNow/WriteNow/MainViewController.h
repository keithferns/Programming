//
//  MainViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface MainViewController : UINavigationController <UITextViewDelegate, UISearchBarDelegate, UIActionSheetDelegate> {
    
	UINavigationController *navigationController;
    NSManagedObjectContext *managedObjectContext;
    UIView *containerView;
    UITextView *textView;
    
}
@property (nonatomic, retain) Memo *newMemo;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIToolbar *myToolBar;
@property (nonatomic, retain) NSString *previousTextInput;

- (void) dismissKeyboard;
- (void) saveMemo;
- (void) addNewAppointment;
- (void) addNewTask;
- (void) addNewFolder;
- (void) addEntity:(id)sender;
- (void) makeActionSheet:(id) sender;

@end
