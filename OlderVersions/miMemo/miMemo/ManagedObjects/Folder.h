//
//  Folder.h
//  miMemo
//
//  Created by Keith Fernandes on 8/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, Memo, Tag;

@interface Folder : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * folderKeyWord;
@property (nonatomic, retain) NSString * folderName;
@property (nonatomic, retain) NSSet* containsFile;
@property (nonatomic, retain) NSSet* folderTag;
@property (nonatomic, retain) NSSet* containsMemo;

@end
