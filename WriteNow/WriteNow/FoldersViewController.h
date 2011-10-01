//
//  FoldersViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomToolBar.h"
#import "WEPopoverController.h"
#import "CustomTextView.h"


@interface FoldersViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, PopoverControllerDelegate> {
    
    NSManagedObjectContext *managedObjectContext;
    UITableViewController *tableViewController;
    
    CustomTextView *textView;
    NSString *sender, *newText;

    BOOL swappingViews, isSelected;
    CustomToolBar *toolBar;
    WEPopoverController *navPopover;

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITableViewController *tableViewController;

@property (nonatomic, retain) NSString *sender, *newText;

@property (nonatomic, retain) CustomTextView *textView;
@property (nonatomic, retain) UITextField *nameField;

@property (nonatomic, retain) CustomToolBar *toolBar;
@property (nonatomic, retain) UIButton *saveNewFolderButton;
@property (nonatomic, retain) WEPopoverController *navPopover;


- (void) makeFolderFile:(id)sender;

- (void) dismissKeyboard;
- (void) makeFolder;
- (void) makeFile;

- (void) addFolderFile:(UIBarButtonItem *)barButtonItem;


@end
