//
//  Memo.h
//  miMemo
//
//  Created by Keith Fernandes on 7/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, Folder, MemoText, Tag;

@interface Memo : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * memoRE;
@property (nonatomic, retain) NSDate * doDate;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * isEditing;
@property (nonatomic, retain) File * appendToFile;
@property (nonatomic, retain) NSSet* memoTag;
@property (nonatomic, retain) MemoText * memoText;
@property (nonatomic, retain) Folder * savedIn;

@end
