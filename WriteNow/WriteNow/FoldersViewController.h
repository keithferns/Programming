//
//  FoldersViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomToolBar.h"

@interface FoldersViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate> {
    
    NSManagedObjectContext *managedObjectContext;
    UITableViewController *tableViewController;
    
    UITextView *textView;
    NSString *sender, *newText;

    BOOL swappingViews, isSelected;
    CustomToolBar *toolbar;

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITableViewController *tableViewController;

@property (nonatomic, retain) NSString *sender, *newText;

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UITextField *textField;

@property (nonatomic, retain) CustomToolBar *toolbar;
@property (nonatomic, retain) UIButton *saveNewFolderButton;



- (void) dismissKeyboard;
- (void) makeFolder;
- (void) makeFile;

- (void) addFolderFile:(UIBarButtonItem *)barButtonItem;

//- (void) swapViews;


@end
