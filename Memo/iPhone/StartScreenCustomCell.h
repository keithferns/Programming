//
//  StartScreenCustomCell.h
//  Memo
//
//  Created by Keith Fernandes on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StartScreenCustomCell : UITableViewCell {

	
	UITextView *memoText;
	UILabel *creationDate;
	UILabel *memoRE;
	
}

@property (nonatomic, retain) IBOutlet UITextView *memoText;
@property (nonatomic, retain) IBOutlet UILabel *creationDate, *memoRE;


@end
