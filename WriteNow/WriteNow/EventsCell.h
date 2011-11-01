//
//  EventsCell.h
//  WriteNow
//
//  Created by Keith Fernandes on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventsCell : UITableViewCell {
    UILabel *textLabel, *dateLabel;
    
}

@property (nonatomic, retain) UILabel *textLabel, *dateLabel;


@end
