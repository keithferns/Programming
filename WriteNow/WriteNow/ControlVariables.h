//
//  ControlVariables.h
//  WriteNow
//
//  Created by Keith Fernandes on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// IPHONE CONSTANTS

#define kScreenRect [[UIScreen mainScreen] applicationFrame]

#define kScreenWidth kScreenRect.size.width

#define kScreenHeight kScreenRect.size.height


// Height of the cells of the embedded table view (after rotation, which would be the table's width)
#define kCellHeight  106

// Width of the cells of the embedded table view (after rotation, which means it controls the rowHeight property)
#define kCellWidth 106

// Padding for the Cell containing the article image and title
#define kArticleCellVerticalInnerPadding            3
#define kArticleCellHorizontalInnerPadding          3

// Padding for the title label in an article's cell
#define kArticleTitleLabelPadding   

// Vertical padding for the embedded table view within the row
#define kRowVerticalPadding                         0
// Horizontal padding for the embedded table view within the row
#define kRowHorizontalPadding                       0


// The background color of the vertical table view
#define kVerticalTableBackgroundColor               [UIColor colorWithRed:0.58823529 green:0.58823529 blue:0.58823529 alpha:1.0]

// Background color for the horizontal table view (the one embedded inside the rows of our vertical table)
#define kHorizontalTableBackgroundColor             [UIColor colorWithRed:0.6745098 green:0.6745098 blue:0.6745098 alpha:1.0]

// The background color on the horizontal table view for when we select a particular cell
#define kHorizontalTableSelectedBackgroundColor     [UIColor colorWithRed:0.0 green:0.59607843 blue:0.37254902 alpha:1.0]
