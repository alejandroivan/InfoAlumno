//
//  IAPHelper.m
//  InfoAlumno
//
//  Created by Alejandro Iván on 01-08-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "IAPHelper.h"

@interface IAPHelper () <SKProductsRequestDelegate>
@end

@implementation IAPHelper
{
    SKProductsRequest *_productsRequest;

    RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}






- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers
{
    
    if ( (self = [super init]) ) {
        _productIdentifiers = productIdentifiers;
        _purchasedProductIdentifiers = [NSMutableSet set];

        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            }
            else
            {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
    }
    return self;
}







- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];

    _productsRequest.delegate = self;
    [_productsRequest start];
}




#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    
    for (SKProduct *skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
        skProduct.productIdentifier,
        skProduct.localizedTitle,
        skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Failed to load list of products.");

    _productsRequest = nil;

    _completionHandler(NO, nil);
    _completionHandler = nil;    
}


@end