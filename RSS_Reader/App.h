//
//  App.h
//  RSS_Reader
//
//  Created by Paola Mata Maldonado on 8/17/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface App : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * iTunesURL;
@property (nonatomic, retain) NSString * summary;

@end
