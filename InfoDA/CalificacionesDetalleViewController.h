//
//  CalificacionesDetalleViewController.h
//  InfoAlumno
//
//  Created by Alejandro Iván on 31-03-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalificacionesDetalleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *detalleAsignatura;
@property (strong, nonatomic) NSString *codigoAsignatura;

- (void)cargarDetalle:(NSDictionary *)asignatura withCodigo:(NSString *)codigo;


@property (strong, nonatomic) IBOutlet UILabel *Label_codigoAsignatura;
@property (strong, nonatomic) IBOutlet UILabel *Label_nombreAsignatura;
@property (strong, nonatomic) IBOutlet UILabel *Label_docenteAsignatura;
@property (strong, nonatomic) IBOutlet UILabel *Label_evaluacionRecuperacionAsignatura;
@property (strong, nonatomic) IBOutlet UILabel *Label_fechaEvaluacionRecuperacionAsignatura;
@property (strong, nonatomic) IBOutlet UILabel *Label_notaFinalAsignatura;

@end
