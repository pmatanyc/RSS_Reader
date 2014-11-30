//
//  PMFavesDetailsViewController.m
//  RSS_Reader
//
//  Created by Paola Mata Maldonado on 8/17/14.
//
//

#import <Social/Social.h>
#import "PMFavesDetailsViewController.h"
#import "App.h"

@interface PMFavesDetailsViewController ()<UIActionSheetDelegate>

@end

@implementation PMFavesDetailsViewController

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

    [self loadData];
    
}

-(void)loadData{
    
    self.nameLabel.text = self.app.name;
    self.artistLabel.text = self.app.artist;
    self.categoryLabel.text = self.app.category;
    self.priceLabel.text = self.app.price;
    self.summaryTextView.text = self.app.summary;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.app.imageURL]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            [self.view setNeedsLayout];
        });
        
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)iTunesButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.app.iTunesURL]];
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
                        [fbPostSheet setInitialText: [NSString stringWithFormat:@"Check out this great game I'm hooked on: %@! %@", self.app.name, self.app.iTunesURL]];
                        //                        how to deal with a redirect?? currently, it is ignored.
                        //                        [fbPostSheet addURL:[NSURL URLWithString:app.iTunesURL]];
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
                        [tweetSheet setInitialText:[NSString stringWithFormat: @"Check out this great app I'm hooked on: %@! %@", self.app.name, self.app.iTunesURL]];
                        //                        [tweetSheet addURL:[NSURL URLWithString:app.iTunesURL]];
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
                    NSString *messageBody = [NSString stringWithFormat:@"I'm hooked on this app called %@. Download today from the App Store!\n%@", self.app.name, self.app.iTunesURL];
                    
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


@end
