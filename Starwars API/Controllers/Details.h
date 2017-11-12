//
//  Details.h
//  Starwars API
//
//  Created by Sergio Martinez on 11/12/17.
//  Copyright © 2017 Boletomovil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Details : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *gender;
@property (strong, nonatomic) IBOutlet UITextField *hair_color;
@property NSDictionary *data;
@end
