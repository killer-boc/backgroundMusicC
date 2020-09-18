// This file is part of Background Music.
//
// Background Music is free software: you can redistribute it and/or
// modify it under the terms of the GNU General Public License as
// published by the Free Software Foundation, either version 2 of the
// License, or (at your option) any later version.
//
// Background Music is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Background Music. If not, see <http://www.gnu.org/licenses/>.

//
//  BGMSpotify.m
//  BGMApp
//
//  Copyright © 2016-2018 Kyle Neideck
//
//  Spotify's AppleScript API looks to have been designed to match iTunes', so this file is basically
//  just s/iTunes/Spotify/ on BGMiTunes.m
//

// Self Include
#import "BGMSpotify.h"

// Auto-generated Scripting Bridge header
#import "Spotify.h"

// Local Includes
#import "BGMScriptingBridge.h"

// PublicUtility Includes
#import "CADebugMacros.h"


#pragma clang assume_nonnull begin

@implementation BGMSpotify {
    BGMScriptingBridge* scriptingBridge;
}

- (instancetype) init {
    // If you're copying this class, replace the ID string with a new one generated by uuidgen. (Command line tool.)
    if ((self = [super initWithMusicPlayerID:[BGMMusicPlayerBase makeID:@"EC2A907F-8515-4687-9570-1BF63176E6D8"]
                                        name:@"Spotify"
                                    bundleID:@"com.spotify.client"])) {
        scriptingBridge = [[BGMScriptingBridge alloc] initWithMusicPlayer:self];
    }
    
    return self;
}

- (SpotifyApplication* __nullable) spotify {
    return (SpotifyApplication* __nullable)scriptingBridge.application;
}

- (void) wasSelected {
    [super wasSelected];
    [scriptingBridge ensurePermission];
}

- (BOOL) isRunning {
    // Note that this will return NO if is self.spotify is nil (i.e. Spotify isn't running).
    return self.spotify.running;
}

// isPlaying and isPaused check self.running first just in case Spotify is closed but self.spotify hasn't become
// nil yet. In that case, reading self.spotify.playerState could make Scripting Bridge open Spotify.

- (BOOL) isPlaying {
    return self.running && (self.spotify.playerState == SpotifyEPlSPlaying);
}

- (BOOL) isPaused {
    return self.running && (self.spotify.playerState == SpotifyEPlSPaused);
}

- (BOOL) pause {
    // isPlaying checks isRunning, so we don't need to check it here and waste an Apple event
    BOOL wasPlaying = self.playing;
    
    if (wasPlaying) {
        DebugMsg("BGMSpotify::pause: Pausing Spotify");
        [self.spotify pause];
    }
    
    return wasPlaying;
}

- (BOOL) unpause {
    // isPaused checks isRunning, so we don't need to check it here and waste an Apple event
    BOOL wasPaused = self.paused;
    
    if (wasPaused) {
        DebugMsg("BGMSpotify::unpause: Unpausing Spotify");
        [self.spotify playpause];
    }
    
    return wasPaused;
}

@end

#pragma clang assume_nonnull end

