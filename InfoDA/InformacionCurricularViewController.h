//
//  InformacionCurricularViewController.h
//  InfoAlumno
//
//  Created by Alejandro Iván on 20-01-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformacionCurricularViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UILabel *totalAsignaturas;
@property (strong, nonatomic) IBOutlet UILabel *promedioPonderado;
@property (strong, nonatomic) IBOutlet UILabel *creditosAprobados;
@property (strong, nonatomic) IBOutlet UILabel *creditosReprobados;
@property (strong, nonatomic) IBOutlet UILabel *carrera;
@property (strong, nonatomic) IBOutlet UILabel *situacionActual;

@property (strong, nonatomic, retain) NSDictionary *informacionCurricular;
@property (strong, nonatomic, retain) NSArray *asignaturas;

- (IBAction)cerrarSesion:(id)sender;
- (void)didBecomeActive;
@end
