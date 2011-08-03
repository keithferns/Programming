//
//  File.h
//  miMemo
//
//  Created by Keith Fernandes on 8/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Folder, Memo, Tag;

@interface File : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSDate * fileKeyWord;
@property (nonatomic, retain) NSDate * lastSaveDate;
@property (nonatomic, retain) NSSet* fileTag;
@property (nonatomic, retain) NSSet* appendMemo;
@property (nonatomic, retain) Folder * savedIn;

@end
