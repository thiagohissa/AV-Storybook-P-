//
//  DataViewController.m
//  AV Storybook (P*)
//
//  Created by Thiago Hissa on 2017-07-14.
//  Copyright © 2017 Thiago Hissa. All rights reserved.
//

#import "DataViewController.h"
@import AVFoundation;

@interface DataViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;

@property (nonatomic,strong) NSURL *audioFileURL;

@property (nonatomic,strong) AVAudioRecorder *recorder;

@property (nonatomic,strong) AVAudioPlayer* player;

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"Our docs directory is %@", docsDir);
    self.audioFileURL = [NSURL URLWithString:[docsDir stringByAppendingPathComponent:@"audio.m4a"]];}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}




// Image stuff

- (IBAction)photoLibraryPickButton:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:^{
        NSLog(@"Presented");
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.mainImage.image = image;
    self.mainImage.alpha = 0.4;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"Cancelled");
}








// Audio stuff


- (IBAction)recordButton:(id)sender {
    if (self.recorder.isRecording) {
        [self.recorder stop];
    //    [sender setTitle:@"Record" forState:UIControlStateNormal];
    } else {
        
                
                NSError *err = nil;
                self.recorder = [[AVAudioRecorder alloc]
                                 initWithURL:self.audioFileURL
                                 settings:@{AVFormatIDKey: @(kAudioFormatMPEG4AAC),
                                            AVSampleRateKey: @(44100),
                                            AVNumberOfChannelsKey: @(2)}
                                 error:&err];
                
                if (err != nil) {
                    NSLog(@"Couldn't create recorder: %@",
                          err.localizedDescription);
                    abort();
                }
        
                [self.recorder record];

        
    }
}






- (IBAction)onTapWillPlayAudio:(id)sender {
    if (self.player.isPlaying) {
        [self.player stop];
   //     [sender setTitle:@"Play" forState:UIControlStateNormal];
    } else {
    //    [sender setTitle:@"Stop" forState:UIControlStateNormal];
        
        NSError *err = nil;
        [self.player play];
        
        if (self.player == nil) {
            self.player = [[AVAudioPlayer alloc]
                           initWithContentsOfURL:self.audioFileURL
                           error:&err];
            if (err != nil) {
                NSLog(@"Couldn't load player: %@", err.localizedDescription);
                abort();
            }
        }
        [self.player play];
    }
}





@end
