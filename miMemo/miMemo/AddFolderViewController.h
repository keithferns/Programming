//
//  AddFolderViewController.h
//  Memo
//
//  Created by Keith Fernandes on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Folder.h"
#import "File.h"
#import "MemoText.h"

@interface AddFolderViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, UITextFieldDelegate> {
        NSManagedObjectContext *managedObjectContext;
        MemoText *newMemoText;
        File *newFile;
        Folder *newFolder;
        BOOL swappingViews;
        UIActionSheet *goActionSheet;
        UITextView *textView;
        UIToolbar *appointmentsToolbar;
        UITextField *folderTextField, *fileTextField, *tagTextField;   
        NSString *newTextInput;
    }
    @property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
    @property (nonatomic, retain) MemoText *newMemoText;
    @property (nonatomic, retain) File *newFile;
    @property (nonatomic, retain) Folder *newFolder;

    @property (nonatomic, retain) UIActionSheet *goActionSheet;
    @property (nonatomic, retain) UIToolbar *folderToolbar;
    @property (nonatomic, retain) UITextView *textView;
    @property (nonatomic, retain) UITextField *fileTextField, *folderTextField, *tagTextField;
    @property (nonatomic, retain) NSString *newTextInput;
    
    //@property (nonatomic, retain) IBOutlet UIView *monthView, *datetimeView;
    
    - (void) swapViews;
    
    - (void) backAction;
    
    - (void) makeFolder;
    - (void) makeFile;
    
    - (void) makeToolbar;
    
    //- (IBAction)monthAction:(id)sender;
    
    @end
