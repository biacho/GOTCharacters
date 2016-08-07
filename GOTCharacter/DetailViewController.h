//
//  DetailViewController.h
//  GOTCharacter
//
//  Created by Tobiasz Czelakowski on 06.08.2016.
//  Copyright © 2016 Tobiasz Czelakowski. All rights reserved.
//

#import "ViewController.h"

@interface DetailViewController : ViewController

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description_abstract;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSData *thumbnail_img;

@end
