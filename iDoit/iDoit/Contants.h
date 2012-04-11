//
//  Constants.h
//  iDoit
//
//  Created by Keith Fernandes on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


//Define the timeZone and TimeZone Offset

#define kTimeZone [NSTimeZone localTimeZone]

#define kTimeZoneOffset [kTimeZone secondsFromGMT]

//Define the frame and dimensions for the application screen
#define kScreenRect [[UIScreen mainScreen] applicationFrame]

#define kScreenWidth kScreenRect.size.width

#define kScreenHeight kScreenRect.size.height

#define kNavBarHeight self.navigationController.navigationBar.frame.size.height

#define kTabBarHeight self.tabBarController.tabBar.frame.size.height

#define mainFrame CGRectMake(kScreenRect.origin.x, self.navigationController.navigationBar.frame.origin.y+kNavBarHeight, kScreenWidth, kScreenHeight-kNavBarHeight)

//Define TopView Properties


#define kTopViewRect CGRectMake(0, self.navigationController.navigationBar.frame.origin.y+kNavBarHeight, kScreenWidth, 115)

//Define BottomView Properties

#define kBottomViewRect CGRectMake(0, kTopViewRect.origin.y+kTopViewRect.size.height+2, kScreenRect.size.width, kScreenRect.size.height-kNavBarHeight-kTopViewRect.size.height-kTabBarHeight)


//Define TextView Properties

#define kTextViewRect CGRectMake(0,0,kScreenWidth, kTopViewRect.size.height)


// Height of the cells of the embedded table view (after rotation, which would be the table's width)
#define kCellHeight  72

// Width of the cells of the embedded table view (after rotation, which means it controls the rowHeight property)
#define kCellWidth 80

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
#define kVerticalTableBackgroundColor [UIColor colorWithRed:0.58823529 green:0.58823529 blue:0.58823529 alpha:1.0]

// Background color for the horizontal table view (the one embedded inside the rows of our vertical table)
#define kHorizontalTableBackgroundColor [UIColor colorWithRed:0.6745098 green:0.6745098 blue:0.6745098 alpha:1.0]

// The background color on the horizontal table view for when we select a particular cell
#define kHorizontalTableSelectedBackgroundColor [UIColor colorWithRed:0.0 green:0.59607843 blue:0.37254902 alpha:1.0]
