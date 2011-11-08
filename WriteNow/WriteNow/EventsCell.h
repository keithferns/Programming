//
//  EventsCell.h
//  WriteNow
//
//  Created by Keith Fernandes on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomTextLabel;

@interface EventsCell : UITableViewCell {
    UILabel *dateLabel;  
//    CustomTextLabel *_myTextLabel;
    UIImageView *_myTextView;
}

@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
//@property (nonatomic, retain) CustomTextLabel *myTextLabel;
@property (nonatomic, retain) UIImageView *myTextView;

@end
