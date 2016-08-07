//
//  FavoriteTableViewController.m
//  GOTCharacter
//
//  Created by Tobiasz Czelakowski on 07.08.2016.
//  Copyright © 2016 Tobiasz Czelakowski. All rights reserved.
//

#import "FavoriteTableViewController.h"
#import "CustomTableViewCell.h"

@interface FavoriteTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation FavoriteTableViewController
{
    NSMutableArray *array;
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


- (IBAction)backButton:(UIButton *)sender
{
    NSLog(@"Back Button...");
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *listIdentifier = @"CustomCell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listIdentifier];
    
    if (cell == nil)
    {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    array = [NSMutableArray new];
    array = [self readFromPlist];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
