//
//  DetailViewController.m
//  GOTCharacter
//
//  Created by Tobiasz Czelakowski on 06.08.2016.
//  Copyright © 2016 Tobiasz Czelakowski. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbanil;

@end

@implementation DetailViewController

@synthesize title = _title;

- (IBAction)back:(UIButton *)sender
{
    NSLog(@"Back Button...");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goToSafari:(UIButton *)sender
{
    NSString *mainURL = @"http://gameofthrones.wikia.com";
    UIApplication *safari = [UIApplication sharedApplication];
    NSString *combineURL = [NSString stringWithFormat:@"%@%@", mainURL, _url];
    NSURL *wikiURL = [[NSURL alloc] initWithString:combineURL];
    [safari openURL:wikiURL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleLabel.text = _title;
    _descriptionLabel.text = _description_abstract;
    
    UIImage *image = [UIImage imageWithData:_thumbnail_img];
    _thumbanil.layer.backgroundColor = [[UIColor clearColor] CGColor];
    _thumbanil.layer.cornerRadius = 50;
    _thumbanil.layer.masksToBounds = YES;
    _thumbanil.layer.borderColor = [[UIColor blackColor] CGColor];
    _thumbanil.layer.borderWidth = 1.0;
    _thumbanil.image = image;    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
