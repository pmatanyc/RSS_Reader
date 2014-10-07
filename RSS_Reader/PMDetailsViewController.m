//
//  PMDetailsViewController.m
//  RSS_Reader
//
//  Created by Paola Mata Maldonado on 8/15/14.
//
//

#import <Social/Social.h>
#import "PMDetailsViewController.h"
#import "PMFavesTableViewController.h"

@interface PMDetailsViewController ()<UIActionSheetDelegate>

//Core Data
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation PMDetailsViewController

@synthesize app;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"App Details";
    
    [self setUpData];
}

-(void)setUpData{
    
    NSArray *details = [self.allEntries objectAtIndex:self.index];
    
    //get image async-ly
    NSArray *urlArray = [details valueForKeyPath:@"im:image"];
    self.imageURL = [[urlArray objectAtIndex:2] valueForKeyPath:@"label"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.imageURL]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            [self.view setNeedsLayout];
        });
        
    });
    
    self.name = [details valueForKeyPath:@"im:name.label"];
    self.artist = [details valueForKeyPath:@"im:artist.label"];
    self.category = [details valueForKeyPath:@"category.attributes.label"];
    self.price = [details valueForKeyPath:@"im:price.label"];
    self.iTunesURL = [details valueForKeyPath:@"link.attributes.href"];
    self.summary = [details valueForKeyPath:@"summary.label"];
    
    //dislays data in UI
    self.nameLabel.text = self.name;
    self.artistLabel.text = self.artist;
    self.categoryLabel.text = self.category;
    self.priceLabel.text = self.price;
    self.summaryTextView.text = self.summary;
    
    
    [self initModelContext];
    
    [self checkWhetherDataIsSaved];
    
}

-(void)checkWhetherDataIsSaved{
    
    //Checks whether app is in core data, and if so, disables Save button
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [[self.managedObjectModel entitiesByName] objectForKey:@"App"];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@",self.name]];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(!result){
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    else if (result.count != 0){
        self.saveButton.enabled = NO;
        NSLog(@"%@ is already saved!", self.name);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)appStoreButtonPressed:(id)sender {

    //works on device but not on simulator!
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.iTunesURL]];
}

- (IBAction)shareButtonPressed:(id)sender {
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Facebook",
                            @"Twitter",
                            @"E-mail",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];

}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:{
                    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
                    {
                        SLComposeViewController *fbPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                        [fbPostSheet setInitialText: [NSString stringWithFormat:@"Check out this great game I'm hooked on: %@! %@", app.name, app.iTunesURL]];

                        [self presentViewController:fbPostSheet animated:YES completion:nil];
                    }
                    else
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"Error"
                                                  message:@"Check your internet connection and make sure at least one FB account is set up on your device."
                                                  delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];

                    }
                }
                    break;
                case 1:{
                    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
                    {
                        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                        [tweetSheet setInitialText:[NSString stringWithFormat: @"Check out this great app I'm hooked on: %@! %@", app.name, app.iTunesURL]];

                        [self presentViewController:tweetSheet animated:YES completion:nil];
                    }
                    else
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"Error"
                                                  message:@"Check your internet connection and make sure at least one FB account is set up on your device."
                                                  delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];
                    }
                }
                    break;
                case 2:{
                    NSString *emailTitle = @"Check out this awesome app!";
                    NSString *messageBody = [NSString stringWithFormat:@"I'm hooked on this app called %@. Download today from the App Store!\n%@", app.name, app.iTunesURL];
                    
                    MFMailComposeViewController *message = [[MFMailComposeViewController alloc] init];
                    message.mailComposeDelegate = self;
                    [message setSubject:emailTitle];
                    [message setMessageBody:messageBody isHTML:NO];
                    
                    // Present mail view controller on screen
                    [self presentViewController:message animated:YES completion:nil];
                }
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (IBAction)saveButtonPressed:(id)sender {
    
    //creates instance of model object and saves to Core Data
        app = [NSEntityDescription insertNewObjectForEntityForName:@"App" inManagedObjectContext:self.managedObjectContext];
    
        app.imageURL = self.imageURL;
        app.name = self.name;
        app.artist = self.artist;
        app.category = self.category;
        app.price = self.price;
        app.iTunesURL = self.iTunesURL;
        app.summary = self.summary;
    
        [self saveContext];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:{
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
        }
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Core Data stack

-(void)initModelContext
{
    self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSString *path = [self archivePath];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
    }
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    
    [self.managedObjectContext setPersistentStoreCoordinator:psc];
    
}

- (void)saveContext
{
    NSError *err = nil;
    BOOL successful = [self.managedObjectContext save:&err];
    if(!successful){
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    NSLog(@"Data Saved");
    self.saveButton.enabled = NO;

}


#pragma mark - Application's Documents directory

-(NSString*)archivePath
{
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentsDirectories objectAtIndex:0];
//    NSLog(@"%@",documentsDirectory);
    return [documentsDirectory stringByAppendingPathComponent:@"Apps.sqlite"];
}
@end
