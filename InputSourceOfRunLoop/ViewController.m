//
//  ViewController.m
//  RunLoop
//
//  Created by s2mh on 26/05/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logClick:(id)sender {
    [[AppDelegate sharedAppDelegate] wakeSecondaryThreadRunLoopWithCommand:self.textField.text];
}

- (IBAction)killClick:(id)sender {
    [[AppDelegate sharedAppDelegate] killSecondaryThreadRunLoop];
}

@end
