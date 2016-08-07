//
//  ViewController.m
//  GOTCharacter
//
//  Created by Tobiasz Czelakowski on 05.08.2016.
//  Copyright © 2016 Tobiasz Czelakowski. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"
#import "DetailViewController.h"
#import "FavoriteTableViewController.h"

@class DetailViewController;

@interface ViewController ()

@property (strong, nonatomic) DetailViewController *detailView;
@property (strong, nonatomic) FavoriteTableViewController *favoriteView;

@property (weak, nonatomic)     IBOutlet UITableView *listTableView;
@property (strong, nonatomic)   NSIndexPath *expendIndexPath;
@property (assign, nonatomic)   BOOL longPressActivate;

@end

@implementation ViewController
{
    NSDictionary *list;
    NSMutableArray *arrayOfLists;
    NSMutableArray *arrayOfFavs;
    NSArray *test;
    __weak IBOutlet UIButton *favoriteButton;
}

- (void)fetchDataFromURL
{
    NSString *URLpath = @"http://gameofthrones.wikia.com/api/v1/Articles/Top?expand=1&category=Characters&limit=75";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLpath]];
    
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:request
                        returningResponse:nil
                        error:nil];
    
    NSError *jsonParasingError = nil;
    
    list = [NSJSONSerialization
            JSONObjectWithData:response
            options:0
            error:&jsonParasingError];
    
    NSArray *displayKeys = @[@"title",
                             @"thumbnail",
                             @"abstract",
                             @"url"];

    
    NSDictionary *dic = [NSDictionary new];
    NSString *str = @"";
    
    for (int i = 0; i < 75; i++)
    {
        NSMutableDictionary *listForTableView = [NSMutableDictionary new];

        for(int j = 0; j < displayKeys.count; j++)
        {
            NSArray *arr = [list objectForKey:@"items"];
            dic = [arr objectAtIndex:i];
            str = [displayKeys objectAtIndex:j];
            
            [listForTableView setValue:[dic valueForKey:str]
                                forKey:str];
        }
        [arrayOfLists addObject:listForTableView];
    }
}

- (void)writeToPlist:(NSMutableArray *)data
{
    NSArray *pathToSave = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathToFolder = [pathToSave objectAtIndex:0];
    NSString *filePath = [pathToFolder stringByAppendingFormat:@"favorite.plist"];
    
    [data writeToFile:filePath atomically:YES];
}

- (NSMutableArray *)readFromPlist
{
    NSArray *pathToSave = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathToFolder = [pathToSave objectAtIndex:0];
    NSString *filePath = [pathToFolder stringByAppendingFormat:@"favorite.plist"];
    
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (fileExist)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        NSLog(@"File exist... :)");
        return arr;
    }
    else
    {
        NSLog(@"File does not exist... :(");
        return nil;
    }
}

// #MARK: Buttons

- (IBAction)favorite:(UIButton *)sender
{
    NSLog(@"Favorite");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.favoriteView = [storyboard instantiateViewControllerWithIdentifier:@"favoriteView"];
    [self presentViewController:self.favoriteView animated:YES completion:nil];
}

- (IBAction)addToFav:(UIButton *)sender
{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.listTableView];
    NSIndexPath *buttonInIndexPath = [self.listTableView indexPathForRowAtPoint:touchPoint];
    NSLog(@"index path.row : %d", buttonInIndexPath.row);
    CustomTableViewCell *cell = [self.listTableView cellForRowAtIndexPath:buttonInIndexPath];

    if (sender.selected)
    {
        sender.selected = NO;
        for (int i = 0; i < arrayOfFavs.count; i++)
        {
            if ([cell.titleLabel.text isEqualToString:[arrayOfFavs objectAtIndex:i]])
            {
                [arrayOfFavs removeObjectAtIndex:i];
                [self writeToPlist:arrayOfFavs];
            }
        }
    }
    else
    {
        sender.selected = YES;
        NSLog(@"title add to fav: %@",cell.titleLabel.text);
        [arrayOfFavs addObject:cell.titleLabel.text];
        [self writeToPlist:arrayOfFavs];
    }
    
    NSLog(@"Fav: %@", arrayOfFavs);
}


// #MARK: Gestures

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint pressSpot = [gestureRecognizer locationInView:self.listTableView];
    
    NSIndexPath *indexPath = [self.listTableView indexPathForRowAtPoint:pressSpot];
    
    if (indexPath == nil)
    {
        NSLog(@"On Table but not on a row");
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        self.longPressActivate = YES;
        [self.listTableView.delegate tableView:self.listTableView didSelectRowAtIndexPath:indexPath];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
             gestureRecognizer.state == UIGestureRecognizerStateCancelled)
    {
        self.longPressActivate = NO;
    }
}

// #MARK: TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *listIdentifier = @"CustomCell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listIdentifier];
    
    if (cell == nil)
    {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listIdentifier];
    }
    
    NSDictionary *temp = [arrayOfLists objectAtIndex:indexPath.row];
    
    cell.url_temp = [temp objectForKey:@"url"];
    
    NSString *path = [temp objectForKey:@"thumbnail"];
    NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
    UIImage *tn = [UIImage imageWithData:dataImage];
    
    cell.thumbnail.layer.backgroundColor = [[UIColor clearColor] CGColor];
    cell.thumbnail.layer.cornerRadius = 10;
    cell.thumbnail.layer.masksToBounds = YES;
    cell.thumbnail.layer.borderColor = [[UIColor grayColor] CGColor];
    cell.thumbnail.layer.borderWidth = 1.0;
    cell.thumbnail.image = tn;
    
    
    NSString *title = [temp objectForKey:@"title"];
    cell.titleLabel.text = title;
    
    NSString *description = [temp objectForKey:@"abstract"];
    cell.descriptionLabel.numberOfLines = 2;
    cell.descriptionLabel.text = description;
    
   
    cell.addFavButton.tag = indexPath.row;
    [cell.addFavButton addTarget:self action:@selector(addToFav:) forControlEvents:UIControlEventTouchUpInside];

    //NSMutableArray *arr = [self readFromPlist];
    //NSLog(@"arr: %@", arr);
    //arrayOfFavs = [self readFromPlist];
    
    if (arrayOfFavs > 0)
    {
        for (int i = 0; i<arrayOfFavs.count; i++)
        {
            if ([cell.titleLabel.text isEqualToString:[arrayOfFavs objectAtIndex:i]])
            {
                cell.addFavButton.selected = YES;
            }
        }
    }
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; // secounds
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = NO;
    [cell addGestureRecognizer:lpgr];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath compare:self.expendIndexPath] == NSOrderedSame)
    {
        return 130;
    }
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.longPressActivate)
    {
        [tableView beginUpdates];
        
        if ([indexPath compare:self.expendIndexPath] == NSOrderedSame)
        {
            self.expendIndexPath = nil;
        }
        else
        {
            self.expendIndexPath = indexPath;
            CustomTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.descriptionLabel.numberOfLines = 5;
        }
        
        [tableView endUpdates];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.detailView = [storyboard instantiateViewControllerWithIdentifier:@"detailView"];
        CustomTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        self.detailView.title = cell.titleLabel.text;
        self.detailView.description_abstract = cell.descriptionLabel.text;
        UIImage *image = cell.thumbnail.image;
        NSData *thumbnailData = UIImageJPEGRepresentation(image, 1.0);
        self.detailView.thumbnail_img = thumbnailData;
        self.detailView.url = cell.url_temp;
        
        [self presentViewController:self.detailView animated:YES completion:nil];
    }
}

// #MARK: View Load
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrayOfLists = [NSMutableArray new]; // init
    arrayOfFavs = [NSMutableArray new];
    
    [self fetchDataFromURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
