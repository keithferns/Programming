//
//  CurrentViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CurrentViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {
    
    NSManagedObjectContext *managedObjectContext;
    UITableViewController *tableViewController;
    UITextView *textView;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UITableViewController *tableViewController;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) Memo *newMemo;
@property (nonatomic, retain) NSString *previousTextInput;


- (void) dismissKeyboard;
- (void) saveMemo;
- (void) addNewAppointment;
- (void) addNewTask;
- (void) addNewFolder;
- (void) addEntity:(id)sender;
- (void) makeActionSheet:(id) sender;

@end
