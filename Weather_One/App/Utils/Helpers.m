//
//  Helpers.m
//  Weather_One
//
//  Created by Nick on 10/23/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import "Helpers.h"
#import "Reachability.h"
#import "UIView+Toast.h"

@implementation Helpers

+ (BOOL)connected {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];

    return networkStatus != NotReachable;
}

+ (void)showNoConnectionAlertInViewController:(UIViewController *)controller {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"The Internet connection seems to be down. Please chack that!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

+ (void)showToast:(NSString *)message duration:(NSTimeInterval)duration inTheView:(UIView *)view {
    [view makeToast:message duration:duration position:CSToastPositionCenter];
}

+ (WHWeatherType)weatherConditionTypeFromWeatherId:(NSInteger)weatherId {
    
    WHWeatherType type;
    
    switch (weatherId) {
        case 200 ... 232: {
            //RainLighting
            type = WHWeatherTypeRainLighting;
            break;
        }
        case 300 ... 321:
        case 500 ... 531: {
            // Rain
            type = WHWeatherTypeRain;
            break;
        }
        case 600 ... 622: {
            // Snow
            type = WHWeatherTypeSnow;
            break;
        }
        case 701 ... 804: {
            if (weatherId == 800) {
                // Sun
                type = WHWeatherTypeSun;
                break;
            } else {
                // Clound
                type = WHWeatherTypeClound;
                break;
            }
        }
        default:
            type = WHWeatherTypeOther;
            break;
    }
    
    return type;
}

@end
