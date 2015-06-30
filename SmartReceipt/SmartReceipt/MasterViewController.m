//
//  MasterViewController.m
//  SmartReceipt
//
//  Created by Michael Rommel on 17.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CoreDataReceiptManager.h"

#import "Receipt.h"
#import "Receipt+Extended.h"

#import "ReceiptViewCell.h"

@interface MasterViewController () {
    BOOL _isEditing;
}

@property (nonatomic, strong) NSArray *receipts;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing:)];
    self.navigationItem.leftBarButtonItem = editButton;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    //self.tableView.backgroundColor = [UIColor clearColor];
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    self.tableView.contentInset = UIEdgeInsetsMake(12, 6, 6, 0);
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // toolbar
    [self.navigationController setToolbarHidden:NO];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(cancelFilter:)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Item0"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(insertNewObject:)];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"Item1"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(insertNewObject:)];
    
    NSArray *buttons = [NSArray arrayWithObjects: cancelButton, item1, item2, nil];
    [self setToolbarItems:buttons animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadReceipts];
}

- (void)cancelFilter:(id)sender
{
    NSLog(@"cancelFilter");
}

- (void)insertNewObject:(id)sender
{
    if([[CoreDataReceiptManager sharedInstance] addReceiptWithTitle:@"New receipt"]) {
        [self reloadReceipts];
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:(self.receipts.count - 1) inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)reloadReceipts {
    self.receipts = [[CoreDataReceiptManager sharedInstance] getAllReceipts];
    [self.tableView reloadData];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Receipt *receipt = [self.receipts objectAtIndex:indexPath.row];
        UIViewController *viewController = [(UINavigationController *)segue.destinationViewController topViewController];
        if ([viewController respondsToSelector:@selector(setReceiptItem:)]) {
            [viewController performSelector:@selector(setReceiptItem:) withObject:receipt];
        }
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.receipts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ReceiptViewCell";
    
    ReceiptViewCell *cell = (ReceiptViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReceiptViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}

- (void)configureCell:(ReceiptViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Receipt *receipt = [self.receipts objectAtIndex:indexPath.row];
    cell.nameLabel.text = receipt.title;
    cell.descLabel.text = receipt.desc;
    cell.categoryLabel.text = @"Some Category";
    cell.thumbnailImageView.image = [receipt getImage];
    
    [cell setClickCallback:^() {
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    }];
    
    // Assign our own background image for the cell
    /*UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;*/
}

- (void)toggleEditing:(id)sender
{
    _isEditing = !_isEditing;
    [self.tableView setEditing:_isEditing];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Receipt *receiptToDelete = [self.receipts objectAtIndex:indexPath.row];
        [[CoreDataReceiptManager sharedInstance] deleteReceipt: receiptToDelete];
        
        [self reloadReceipts];
    }
}

@end
