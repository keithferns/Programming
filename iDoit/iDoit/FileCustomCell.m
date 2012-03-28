//
//  FileCustomCell.m
//  WriteNow
//
//  Created by Keith Fernandes on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileCustomCell.h"


@implementation FileCustomCell
@synthesize fileName, fileText;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
    [fileName release];
    [fileText release];
}


@end

