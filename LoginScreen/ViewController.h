//
//  ViewController.h
//  LoginScreen
//
//  Created by VS on 26/02/2014.
//  Copyright (c) 2014 VS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textUsername;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
- (IBAction)loginClicked:(id)sender;
- (IBAction)backgroundClick:(id)sender;

@end




