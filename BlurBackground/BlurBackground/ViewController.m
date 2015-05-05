//
//  ViewController.m
//  BlurBackground
//
//  Created by Pradeep Kumar Yadav on 04/05/15.
//  Copyright (c) 2015 Pradeep Kumar Yadav. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.blurImageView.image = [self addBlurredView:self.view blur:7.0];
  
  //Open comment to test blur image
 // self.blurImageView.image = [self getBlurredImageFromImage:[UIImage imageNamed:@"ImageSafari"] blur:7.0];

  //self.blurImageView.alpha = 0.7;
  // Do any additional setup after loading the view, typically from a nib.
}


/**
 * This method is used to blur main view.
 */

- (UIImage*)addBlurredView:(UIView *)screenView blur:(float)blurValue
{
  // Create a graphics context for creating the Image from the UIView
  UIGraphicsBeginImageContext(screenView.bounds.size);
  
  // Render the screen in the current graphics contect
  [screenView.layer renderInContext:UIGraphicsGetCurrentContext()];
  
  // Get the UIImage of the view
  UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
 
  UIGraphicsEndImageContext();
  
  CGRect rectCrop = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
  
  //Create the ImageRef with the rect of device size
  CGImageRef imageRef = CGImageCreateWithImageInRect([viewImage CGImage], rectCrop);
  
  //Create the UIImage from the imageRef 
  UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:viewImage.imageOrientation];
  
  //Create a core image input context
  CIContext *context = [CIContext contextWithOptions:nil];
  
  //Create a new image from content of previous image
  CIImage *inputImage = [CIImage imageWithCGImage:newImage.CGImage];
  
  // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
  CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
  
  //Set the input image
  [filter setValue:inputImage forKey:kCIInputImageKey];
  
  //Set the input radius - Chnage this value for different blur level
  [filter setValue:[NSNumber numberWithFloat:blurValue] forKey:@"inputRadius"];
  
  //get the output for image
  CIImage *result = [filter valueForKey:kCIOutputImageKey];
  
  // CIGaussianBlur has a tendency to shrink the image a little,
  // this ensures it matches up exactly to the bounds of our original image
  CGImageRef cgImage  = [context createCGImage:result fromRect:[inputImage extent]];
  
  //Create the UIImage from the new blurred image
  UIImage *imgRef = [[UIImage alloc]initWithCGImage:cgImage];
  
  return imgRef;
}



-(UIImage*)getBlurredImageFromImage:(UIImage*)viewImage blur:(float)blurValue
{
     //Create a core image input context
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //Create a new image from content of previous image
    CIImage *inputImage = [CIImage imageWithCGImage:viewImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    
    //Set the input image
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    //Set the input radius - Chnage this value for different blur level
    [filter setValue:[NSNumber numberWithFloat:blurValue] forKey:@"inputRadius"];
    
    //get the output for image
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage  = [context createCGImage:result fromRect:[inputImage extent]];
    
    //Create the UIImage from the new blurred image
    UIImage *imgRef = [[UIImage alloc]initWithCGImage:cgImage];
    
    return imgRef;

}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
