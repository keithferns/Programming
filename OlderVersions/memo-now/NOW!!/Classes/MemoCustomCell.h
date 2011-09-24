//
//  MemoCustomCell.h
//  NOW!!
//
//  Created by Keith Fernandes on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MemoCustomCell : UITableViewCell {
	
	UITextView *memoText;
	UILabel *creationDate;
}

@property (nonatomic, retain) IBOutlet UITextView *memoText;
@property (nonatomic, retain) IBOutlet UILabel *creationDate;


@end
