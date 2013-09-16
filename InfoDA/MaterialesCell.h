//
//  MaterialesCell.h
//  InfoAlumno
//
//  Created by Alejandro Iván on 10-06-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileDownloader.h"

@interface MaterialesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *subtitulo;
@property (weak, nonatomic) IBOutlet UIImageView *imagenDescarga;
@property (weak, nonatomic) IBOutlet UIImageView *imagenCheck;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) NSDictionary *material;

@end
