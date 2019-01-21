//
//  ViewController.m
//  HDFPSLabelDemo
//
//  Created by jiamengqiang on 2019/1/21.
//  Copyright © 2019 Jia. All rights reserved.
//

#import "ViewController.h"
#import "HDFPSLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    HDFPSLabel* label = [[HDFPSLabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds)-50, CGRectGetMidY(self.view.bounds)-15, 100, 30)];
    [self.view addSubview:label];
    
}


@end
