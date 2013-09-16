//
//  MaterialesViewController.h
//  InfoAlumno
//
//  Created by Alejandro Iván on 11-05-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIDocumentInteractionControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *materiales;
@property (strong, nonatomic) NSMutableArray *descargas;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)cerrarSesion:(id)sender;
- (void)didBecomeActive;

@end
