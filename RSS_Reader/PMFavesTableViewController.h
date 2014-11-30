//
//  PMFavesTableViewController.h
//  RSS_Reader
//
//  Created by Paola Mata Maldonado on 8/17/14.
//
//

#import <UIKit/UIKit.h>
#import "App.h"

@interface PMFavesTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *favorites;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic)NSString *artist;
@property (strong, nonatomic)NSString *category;
@property (strong, nonatomic)NSString *price;
@property (strong, nonatomic)NSString *iTunesURL;
@property (strong, nonatomic)NSString *summary;


@end
