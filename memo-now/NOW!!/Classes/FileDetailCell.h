//
//  FileDetailCell.h
//  NOW!!
//
//  Created by Keith Fernandes on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FileDetailCell : UITableViewCell {

	UILabel *fileName, *timeStamp;
	UITextView *memoText;
}

@property (nonatomic, retain) IBOutlet UILabel *fileName, *timeStamp;
@property (nonatomic, retain) IBOutlet UITextView *memoText;

@end
