//
//  IAPHelper.h
//  InfoAlumno
//
//  Created by Alejandro Iván on 01-08-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

@end