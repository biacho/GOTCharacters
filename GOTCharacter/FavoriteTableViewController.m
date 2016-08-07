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

- (void)writeToPlist:(NSMutableArray *)data
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *pathToSave = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathToFolder = [pathToSave lastObject];
    NSString *filePath = [pathToFolder stringByAppendingFormat:@"/favorite.plist"];
    
    if (![fileManager fileExistsAtPath:filePath])
    {
        NSString *source = [[NSBundle mainBundle] pathForResource:@"favorite" ofType:@"plist"];
        [fileManager copyItemAtPath:source toPath:filePath error:nil];
    }
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        [data writeToFile:filePath atomically:YES];
    }
    else
    {
        NSLog(@"Something go wrong...");
    }
}

- (NSMutableArray *)readFromPlist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *pathToSave = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathToFolder = [pathToSave objectAtIndex:0];
    NSString *filePath = [pathToFolder stringByAppendingFormat:@"/favorite.plist"];
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTable" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *listIdentifier = @"CustomCell";
    //CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listIdentifier];
    
    /*
    if (cell == nil)
    {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listIdentifier];
    }
    
    cell.titleLabel.text = [array objectAtIndex:indexPath.row];
    cell.descriptionLabel.text = [array objectAtIndex:indexPath.row];
    cell.thumbnail.image = [UIImage imageNamed:@"add.png"];
    cell.addFavButton.selected = YES;
    */
    
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"Delete: %@", [array objectAtIndex:indexPath.row]);
        [array removeObjectAtIndex:indexPath.row];
        [self writeToPlist:array];
        [tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    array = [NSMutableArray new];
    array = [self readFromPlist];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
