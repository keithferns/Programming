//
//  Memo.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Memo :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * memoText;
@property (nonatomic, retain) NSString * keyWords;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSNumber * isEditing;
@property (nonatomic, retain) NSDate * lastEditTimeStamp;




@end



