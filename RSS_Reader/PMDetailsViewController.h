//
//  PMDetailsViewController.h
//  RSS_Reader
//
//  Created by Paola Mata Maldonado on 8/15/14.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@class PMEntry;

@interface PMDetailsViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UITextView *summaryTextView;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic)PMEntry *entry;

- (IBAction)appStoreButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end
