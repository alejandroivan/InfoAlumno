//
//  INFODA_Conexion.h
//  InfoDA
//
//  Created by Alejandro Iván on 12-01-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import "Conexion.h"

@interface INFODA_Conexion : Conexion

// Selector para iniciar sesión, para efectuar consultas posteriores, usar initWithDelegate:success:fail:
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
