//
//  MyFoldersViewController.h
//  miMemo
//
//  Created by Keith Fernandes on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Folder.h"
#import "Tag.h"

@interface MyFoldersViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {
    
	UIActionSheet *goActionSheet, *saveActionSheet;
    UIToolbar *toolbar;
    UITableViewController *tableViewController;
}


@property (nonatomic, retain) UIActionSheet *goActionSheet, *saveActionSheet;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UITableViewController *tableViewController;


- (void) makeToolbar;
- (IBAction) navigationAction:(id)sender;

@end
