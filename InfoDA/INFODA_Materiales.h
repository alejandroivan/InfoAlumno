//
//  INFODA_Materiales.h
//  InfoAlumno
//
//  Created by Alejandro Iván on 07-06-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//


/*
 * Al igual que en INFODA_Calificaciones, se obtiene el HTML de la sección de materiales, se parsea
 * en el WebService y se devuelve el JSON al delegate, para que lo muestre de la manera que estime
 * conveniente. Debería ser llamado en MaterialesViewController.
 *
 * initWithDelegate:success:fail:
 *
 * Delegate es el objeto que instanció la clase (puede ser otro, depende de la referencia entregada).
 * Success es el selector del método que recibirá el JSON.
 * Fail es el selector del método que se llamará en caso de error.
 */

#import "Conexion.h"

@interface INFODA_Materiales : Conexion

@end
