//
//  CalificacionesViewController.h
//  InfoAlumno
//
//  Created by Alejandro Iván on 21-01-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalificacionesDetalleViewController.h"

@interface CalificacionesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSDictionary *calificaciones;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)cerrarSesion:(id)sender;
- (void)didBecomeActive;

@end
