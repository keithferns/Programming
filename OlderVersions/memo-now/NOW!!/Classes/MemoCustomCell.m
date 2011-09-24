//
//  MemoCustomCell.m
//  NOW!!
//
//  Created by Keith Fernandes on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MemoCustomCell.h"

@implementation MemoCustomCell

@synthesize memoText, creationDate;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		
		[self.memoText setFont:[UIFont fontWithName:@"TimesNewRomanPSMT" size:12]];
	
	}
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
