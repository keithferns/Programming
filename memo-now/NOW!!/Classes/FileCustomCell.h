//
//  FileCustomCell.h
//  NOW!!
//
//  Created by Keith Fernandes on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FileCustomCell : UITableViewCell {

	
	UILabel	*timeStamp;
	UILabel *fileName;
	
}

@property (nonatomic, retain) IBOutlet UILabel *timeStamp, *fileName;


@end
