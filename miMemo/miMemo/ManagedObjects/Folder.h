//
//  Folder.h
//  miMemo
//
//  Created by Keith Fernandes on 7/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, Tag;

@interface Folder : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * folderKeyWord;
@property (nonatomic, retain) NSString * folderName;
@property (nonatomic, retain) NSSet* folderTag;
@property (nonatomic, retain) NSSet* contains;

@end
