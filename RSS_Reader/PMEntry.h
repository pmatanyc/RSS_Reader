//
//  Entry.h
//  RSS_Reader
//
//  Created by Paola Mata Maldonado on 11/21/14.
//
//

#import <Foundation/Foundation.h>

@interface PMEntry : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * artist;
@property (nonatomic, strong) NSString * category;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * imageURL;
@property (nonatomic, strong) NSString * iTunesURL;
@property (nonatomic, strong) NSString * summary;

@end
