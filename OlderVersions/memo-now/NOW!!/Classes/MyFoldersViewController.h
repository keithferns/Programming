//  MyFoldersViewController.h
//  NOW!!
//  Created by Keith Fernandes on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>


@interface MyFoldersViewController : UIViewController <UISearchBarDelegate> {

	UITableViewController *tableViewController;
	UITableView *tableView;
	UIView *topView, *bottomView;
	UILabel	*viewLabel;
	UITextView *textView;
	UITextField *textField;
}

@property (nonatomic, retain) IBOutlet UITableViewController *tableViewController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIView *topView, *bottomView;
@property (nonatomic, retain) IBOutlet UILabel *viewLabel;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UITextField *textField;
	//@property (nonatomic, retain) IBOutlet UIButton *doneButton;


-(IBAction) navigationAction:(id)sender;


@end
