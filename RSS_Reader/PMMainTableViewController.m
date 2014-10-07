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

@interface PMMainTableViewController ()

@end

@implementation PMMainTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Top Grossing Apps";
    UIBarButtonItem *favorites = [[UIBarButtonItem alloc]initWithTitle:@"Favorites" style:UIBarButtonItemStylePlain target:self action:@selector(favoritesButtonPressed:)];
    self.navigationItem.rightBarButtonItem = favorites;
    
    NSURL *url = [NSURL URLWithString:@"http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topgrossingapplications/sf=143441/limit=25/json"];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self];
    
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
    return [self.names count];
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
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = [NSString stringWithFormat:@"%i. %@",indexPath.row + 1,[self.names objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = [self.categories objectAtIndex:indexPath.row];
    cell.imageView.image = nil;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [self.imageURLs objectAtIndex:indexPath.row]]];
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
    
    // Pass the selected object to the new view controller.
    detailViewController.allEntries = self.allEntries;
    detailViewController.index = indexPath.row;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&error];
    self.allEntries = [json valueForKeyPath:@"feed.entry"];
    
    if (error != nil) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    else{
        
        self.names = [json valueForKeyPath:@"feed.entry.im:name.label"];
        self.categories = [json valueForKeyPath:@"feed.entry.category.attributes.label"];
        NSArray *urlArray = [json valueForKeyPath:@"feed.entry.im:image.label"];
         self.imageURLs = [[NSMutableArray alloc]init];
        
        for (NSArray *urls in urlArray) {
    //using first image, as it is smallest
            NSString *url = [urls objectAtIndex:0];
            [self.imageURLs addObject: url];
        }
        
    }
    [self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

@end
