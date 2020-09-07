# BBB4Nix

## What
BigBlueButton packaging for Nix and NixOS

That includes [packages](packages/README.md) and [modules](modules/README.md) for all relevant components.

## Why
The official setup instructions are "just download this script and run it on a Ubuntu 16.04".
If you ever want to change anything, like your domain, afterwards, you're SOL.

## How
The code is right there, you probably don't want to read it, I wouldn't, but feel free.


### Notes
We deploy this together with our deployment/configuration management/whatever project.
Some stub modules are included for compatibility, but we don't test this "standalone".

### Known issues
When not using helsinki, you need to enable AES256-GCM-SHA384 or another cipher compatible with node.js 8.x (used by bbb html5) in your nginx.
Also some ports need to be opened for WebRTC etc.

Recording and Playback does not work. This is due to the fact that it is:
1) most likely not GDPR compliant (https://docs.bigbluebutton.org/admin/privacy.html)
2) implemented very interestingly (there is a branch which mostly gets it working, look at that to see what I mean)
3) will work differently in bbb 2.3
