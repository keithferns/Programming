//
//  FileCustomCell.h
//  NOW!!
//
//  Created by Keith Fernandes on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FileCustomCell : UITableViewCell {

	
	UILabel *fileName;
	UITextView *fileText;
	
}

@property (nonatomic, retain) IBOutlet UILabel *fileName;
@property (nonatomic, retain) IBOutlet UITextView *fileText;


@end
