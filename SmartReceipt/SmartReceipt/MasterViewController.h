//
//  MasterViewController.h
//  SmartReceipt
//
//  Created by Michael Rommel on 17.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end

