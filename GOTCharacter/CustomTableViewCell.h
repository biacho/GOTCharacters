//
//  CustomTableViewCell.h
//  GOTCharacter
//
//  Created by Tobiasz Czelakowski on 06.08.2016.
//  Copyright © 2016 Tobiasz Czelakowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *addFavButton;
@property (weak, nonatomic) NSString *url_temp;

@end
