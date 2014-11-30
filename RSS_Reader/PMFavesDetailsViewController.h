//
//  PMFavesDetailsViewController.h
//  RSS_Reader
//
//  Created by Paola Mata Maldonado on 8/17/14.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@class App;

@interface PMFavesDetailsViewController : UIViewController< MFMailComposeViewControllerDelegate>

@property (strong, nonatomic)App *app;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UITextView *summaryTextView;

- (IBAction)iTunesButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;

@end
