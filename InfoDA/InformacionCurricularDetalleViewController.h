//
//  InformacionCurricularDetalleViewController.h
//  InfoAlumno
//
//  Created by Alejandro Iván on 06-02-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformacionCurricularDetalleViewController : UIViewController

@property (strong, nonatomic) NSDictionary *asignatura;

- (void)cargarDetalle:(NSDictionary *)asignatura;

@property (strong, nonatomic) IBOutlet UILabel *Label_NombreAsignatura;
@property (strong, nonatomic) IBOutlet UILabel *Label_CodigoAsignatura;
@property (strong, nonatomic) IBOutlet UILabel *Label_PeriodoAsignatura;
@property (strong, nonatomic) IBOutlet UILabel *Label_CreditosAsignatura;
@property (strong, nonatomic) IBOutlet UILabel *Label_NotaAsignatura;
@property (strong, nonatomic) IBOutlet UILabel *Label_EstadoAsignatura;
@end
