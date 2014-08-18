//
//  PMDetailsViewController.h
//  RSS_Reader
//
//  Created by Paola Mata Maldonado on 8/15/14.
//
//

#import <UIKit/UIKit.h>
#import "App.h"
#import <MessageUI/MessageUI.h>

@interface PMDetailsViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSArray *allEntries;
@property (nonatomic) int index;

@property (strong,nonatomic) App *app;


//View Outlets & Button methods
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UITextView *summaryTextView;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;


@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic)NSString *artist;
@property (strong, nonatomic)NSString *category;
@property (strong, nonatomic)NSString *price;
@property (strong, nonatomic)NSString *iTunesURL;
@property (strong, nonatomic)NSString *summary;




- (IBAction)appStoreButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;

- (IBAction)saveButtonPressed:(id)sender;



@end
