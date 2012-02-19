//
//  Constants.h
//  iDoit
//
//  Created by Keith Fernandes on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


//Define the frame and dimensions for the application screen
#define kScreenRect [[UIScreen mainScreen] applicationFrame]

#define kScreenWidth kScreenRect.size.width

#define kScreenHeight kScreenRect.size.height

#define kNavBarHeight self.navigationController.navigationBar.frame.size.height

#define kTabBarHeight self.tabBarController.tabBar.frame.size.height

//Define TopView Properties


#define kTopViewRect CGRectMake(0, self.navigationController.navigationBar.frame.origin.y+kNavBarHeight, kScreenWidth, 115)

//Define BottomView Properties

#define kBottomViewRect CGRectMake(0, kTopViewRect.origin.y+kTopViewRect.size.height, kScreenRect.size.width, kScreenRect.size.height-kTopViewRect.origin.y-kTopViewRect.size.height-kTabBarHeight)


//Define TextView Properties

#define kTextViewRect CGRectMake(0,0,kScreenWidth, kTopViewRect.size.height)