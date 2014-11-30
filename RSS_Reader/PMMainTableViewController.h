//
//  PMMainTableViewController.h
//  RSS_Reader
//
//  Created by Paola Mata Maldonado on 8/14/14.
//
//

#import <UIKit/UIKit.h>
#import "PMDataServices.h"

@interface PMMainTableViewController : UITableViewController<NSURLConnectionDelegate, DataServicesProtocol>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(strong, nonatomic) NSArray *allEntries;


@end
