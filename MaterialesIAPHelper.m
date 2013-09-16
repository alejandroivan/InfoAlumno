//
//  MaterialesIAPHelper.m
//  InfoAlumno
//
//  Created by Alejandro Iván on 01-08-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import "MaterialesIAPHelper.h"

@implementation MaterialesIAPHelper

+ (MaterialesIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static MaterialesIAPHelper *sharedInstance;
    
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"cl.iosdevel.InfoAlumno.DescargarMateriales",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    
    return sharedInstance;
}

@end
