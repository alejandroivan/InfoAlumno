//
//  MaterialesCell.m
//  InfoAlumno
//
//  Created by Alejandro Iván on 10-06-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import "MaterialesCell.h"

@implementation MaterialesCell
{
    BOOL isDownloading;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        isDownloading = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
