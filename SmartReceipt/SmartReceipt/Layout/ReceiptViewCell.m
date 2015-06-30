//
//  TableViewCell.m
//  SmartReceipt
//
//  Created by Michael Rommel on 25.06.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import "ReceiptViewCell.h"

@interface ReceiptViewCell()
{
    ReceiptViewCellClickedBlock _receiptViewCellClickedBlock;
}

@end

@implementation ReceiptViewCell

@synthesize nameLabel = _nameLabel;
@synthesize descLabel = _descLabel;
@synthesize categoryLabel = _categoryLabel;
@synthesize thumbnailImageView = _thumbnailImageView;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if(_receiptViewCellClickedBlock && selected) {
        _receiptViewCellClickedBlock();
    }
}

- (void)setClickCallback:(ReceiptViewCellClickedBlock)receiptViewCellClickedBlock
{
    _receiptViewCellClickedBlock = receiptViewCellClickedBlock;
}

@end
