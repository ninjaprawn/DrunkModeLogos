#import "PSSpecifier.h"

#define PreferencesPlist @"/var/mobile/Library/Preferences/me.qusic.drunkmode.plist"
#define DrunkModeKey @"DrunkMode"

static BOOL getDrunkMode()
{
    NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:PreferencesPlist];
    return [[preferences objectForKey:DrunkModeKey]boolValue];
}
static void setDrunkMode(BOOL value)
{
    NSMutableDictionary *preferences = [NSMutableDictionary dictionary];
    [preferences addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:PreferencesPlist]];
    [preferences setObject:[NSNumber numberWithBool:value] forKey:DrunkModeKey];
    [preferences writeToFile:PreferencesPlist atomically:YES];
}

%hook CKTranscriptController
-(void)messageEntryViewSendButtonHit:(id)messageEntryView {
    if (getDrunkMode()) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Drunk Mode"  message:@"Go Home, You Are Drunk!" delegate:nil cancelButtonTitle:@"What?" otherButtonTitles:nil];
        [alertView show];
    } else {
        %orig();
    }
}

%end

%hook PrefsListController
-(NSMutableArray *) specifiers {

    NSMutableArray *specifiers = %orig;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Drunk Mode"
                                                                                      target:self
                                                                                         set:@selector(setDrunkMode:specifier:)
                                                                                         get:@selector(getDrunkMode:)
                                                                                      detail:Nil
                                                                                        cell:PSSwitchCell
                                                                                        edit:Nil];
        [specifier setIdentifier:DrunkModeKey];
        [specifier setProperty:[NSNumber numberWithBool:YES] forKey:@"enabled"];
        [specifier setProperty:[NSNumber numberWithBool:YES] forKey:@"alternateColors"];
        [specifier setProperty:[UIImage imageWithContentsOfFile:@"/Library/Application Support/DrunkMode/DrunkMode.png"] forKey:@"iconImage"];
        [specifier setProperty:@"Settings-DrunkMode" forKey:@"iconCache"];
        
        [specifiers insertObject:specifier atIndex:2];
    });
    
    return specifiers;
}

%new -(id)getDrunkMode:(PSSpecifier*)specifier {
    return [NSNumber numberWithBool:getDrunkMode()];
}

%new -(void)setDrunkMode:(id)value specifier:(PSSpecifier *) specifier {
    setDrunkMode([value boolValue]);
}

%end