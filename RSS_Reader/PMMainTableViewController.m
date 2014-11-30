//
//  PMMainTableViewController.m
//  RSS_Reader
//
//  Created by Paola Mata Maldonado on 8/14/14.
//
//

#import "PMMainTableViewController.h"
#import "PMDetailsViewController.h"
#import "PMFavesTableViewController.h"
#import "PMEntry.h"

@interface PMMainTableViewController ()

@property (strong, nonatomic)PMDataServices *coreDataServices;

@end

@implementation PMMainTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _allEntries = [NSArray new];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Top Grossing Apps";
    UIBarButtonItem *favorites = [[UIBarButtonItem alloc]initWithTitle:@"Favorites" style:UIBarButtonItemStylePlain target:self action:@selector(favoritesButtonPressed:)];
    self.navigationItem.rightBarButtonItem = favorites;
    
    self.coreDataServices = [[PMDataServices alloc]init];
    self.coreDataServices.delegate = self;
    [self.coreDataServices getAppData];

}


-(void)receivedData:(NSArray *)entries{
    
    self.allEntries = entries;
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)favoritesButtonPressed:(id)sender{
    
    PMFavesTableViewController *favesTVC = [[PMFavesTableViewController alloc]initWithNibName:@"PMFavesTableViewController" bundle:nil];
    [self.navigationController pushViewController:favesTVC animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.allEntries count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.font  = [UIFont systemFontOfSize:15.0];
    }

    // Configure the cell...
    
    PMEntry *entry = [self.allEntries objectAtIndex:indexPath.row];
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = entry.name;
    cell.detailTextLabel.text = entry.category;
    cell.imageView.image = nil;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: entry.imageURL]];
        UIImage *image = [UIImage imageWithData:imageData];

        dispatch_sync(dispatch_get_main_queue(), ^{
            cell.imageView.image = image;
            [cell setNeedsLayout];
        });
        
    });
    return cell;
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PMDetailsViewController *detailViewController = [[PMDetailsViewController alloc] initWithNibName:@"PMDetailsViewController" bundle:nil];
    
    detailViewController.entry = [self.allEntries objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end
