# irc2png

## Demo video

Short (prototyping stage)
https://youtu.be/T-ENFAmNoow

Long (final result - I've created irc2png specifically for this video)
https://youtu.be/O5YAEiOt3Ic

## What is this for?

**Generate a beautiful animated PNG sequence from an IRC log.**

Imagine you have some messages copied from IRC, and you'd liek to present the min video form like they are appearing in real time. With this tool you can do that.

This is a bash script that takes an IRC log from a txt file along with an SVG template, and produces a PNG sequence that you can then use to overlay the chat replay in a video.

I've made it, becasue I needed it, but maybe you'll fine it useful.

The current SVG template has 8 lines of chat, and the script is specifically made to work with that.
It replaces strings in the SVG file and renders it out using ImageMagick to a transparent PNG sequence.

If you then import that sequence with FPS value of 1 (one frame per second), you'll have an animated IRC chat replay ready to use in a video editor.

You can customize the SVG template to suit your needs, change the fonts, number of lines, layout etc. - though if you change the line amount, you'll need to modify the script too. At some point this should be automated, but for now - it's rigid.

The IRC parsing is very basic and only works properly with user messages - channel messages like leave/join will break it, so I just removed them manually in the IRC log. Also: if smeone uses a `\` character - it'll break the script. Just sayin'

## How to use it?

Just run the script and read the built-in help.

For a quick test, clone or download this repository to your disk, and run:

    ./irc2png.sh irc.txt template.svg
    
It should create a `./irc2png` subdirectory filled with PNG frames.

## Cool features to brag about

The process is optimized to only render frames that are necessary and will copy over frames to pad the distance in the PNG sequence waiting for a new message to arrive in the IRC log. This made it like 100 times faster than before.

It's also using `cp --reflink` to copy the files so if you're on Btrfs or ZFS - it'll be even faster and use much less disk space, as only references to the files will be stored, the actual data blocks being re-used for all duplicates.

This could probably be just as well be replaced with symbolic links to make it work and save space on ext4 also.

## Not so cool un-features I shamefully acknowledge

I know this code is very ugly, but I needed to do one specific thing and I couldn't find a satisfying solution anywhere. Feel free to submit improvements, if you've made any.

Enjoy!
