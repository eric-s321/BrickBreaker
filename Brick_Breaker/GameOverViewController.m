
#import <Foundation/Foundation.h>
#import "GameOverViewController.h"
#import "Universe.h"

@implementation GameOverViewController
@synthesize scoreLabel, textField;

-(void)viewDidLoad{
    int score = [[Universe sharedInstance] currentScore];
    scoreLabel.text = [NSString stringWithFormat:@"Score: %d", score];
}

-(IBAction)submitHighScore{
    
    NSLog(@"In submit high score");
    NSLog(@"Text field says: %@", textField.text);
    NSLog(@"Score is %d", [[Universe sharedInstance] currentScore]);
    HighScore *highScore = [[HighScore alloc] init];
    highScore.name = textField.text;
    highScore.score = [[Universe sharedInstance] currentScore];
    [[Universe sharedInstance] addHighScore:highScore];
    
    [self performSegueWithIdentifier:@"showHighScores" sender:self];
    
}

-(IBAction)dismissKeyboard:(id)sender{
    [self resignFirstResponder];
}

@end
