//
//  PMFavesTableViewController.m
//  RSS_Reader
//
//  Created by Paola Mata Maldonado on 8/17/14.
//
//

#import "PMFavesTableViewController.h"
#import "PMFavesDetailsViewController.h"
#import "PMDataServices.h"

@interface PMFavesTableViewController ()

@property(nonatomic, strong)PMDataServices *coreDataServices;

@end

@implementation PMFavesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.coreDataServices = [PMDataServices new];
    [self.coreDataServices initModelContext];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"My Favorites";
    [self loadData];
}

-(void)loadData
{
    self.favorites = [self.coreDataServices fetchRequest];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.favorites count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.font  = [UIFont systemFontOfSize:15.0];
    }
    
    App *app = [self.favorites objectAtIndex:indexPath.row];
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = app.name;
    cell.detailTextLabel.text = app.category;
    cell.imageView.image = nil;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: app.imageURL]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            cell.imageView.image = image;
            [cell setNeedsLayout];
        });
        
    });

    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [self.coreDataServices deleteObject:[self.favorites objectAtIndex:indexPath.row]];
        [self.coreDataServices saveContext];
        
        [self loadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    PMFavesDetailsViewController *favesDetailsTVC = [[PMFavesDetailsViewController alloc] initWithNibName:@"PMFavesDetailsViewController" bundle:nil];
    
    favesDetailsTVC.app = [self.favorites objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:favesDetailsTVC animated:YES];
}


@end
