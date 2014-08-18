//
//  PMMainTableViewController.h
//  RSS_Reader
//
//  Created by Paola Mata Maldonado on 8/14/14.
//
//

#import <UIKit/UIKit.h>

@interface PMMainTableViewController : UITableViewController<NSURLConnectionDelegate>

{
    NSMutableData *_responseData;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *names;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSMutableArray *imageURLs;

@property(strong, nonatomic) NSArray *allEntries;

@end
