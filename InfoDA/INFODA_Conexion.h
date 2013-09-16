//
//  INFODA_Conexion.h
//  InfoDA
//
//  Created by Alejandro Iván on 12-01-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//


/*
 * Esta clase genera la conexión a InfoAlumno (inicio de sesión para acceder a información).
 * Es una subclase de la clase Conexion y utiliza sus métodos.
 * Usualmente solo debiera usarse una vez para iniciar sesión antes de pedir información.
 *
 * Luego, para consultas a información privada (y evitar el timeout de la sesión en el servidor),
 * se utilizarían los métodos de initSessionRestoreWithDelegate:withSelector: junto a
 * initSessionRestoreWithDelegate:withSelector:withErrorSelector:
 */

#import "Conexion.h"

@interface INFODA_Conexion : Conexion

- (id)initWithUsername:(NSString *)username
          withPassword:(NSString *)password
          withDelegate:(id)delegate
               success:(SEL)success
                  fail:(SEL)fail;

- (id)initSessionRestoreWithDelegate:(id)delegate
                        withSelector:(SEL)selector;

- (id)initSessionRestoreWithDelegate:(id)delegate
                        withSelector:(SEL)selector
                   withErrorSelector:(SEL)errorSel;
@end
