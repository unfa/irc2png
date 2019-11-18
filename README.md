# IRC2PNG
Generate a beautiful animated PNG sequence from an IRC log

This is a bash script that takes an IRC log from a txt file along wiht an SVG template, and produces a PNG sequence that you can then use to overlay the chat replay in a video.

I've made it, becasue I needed it, but maybe you'll fine it useful.

It's very non-flexible.

The current SVG template has 8 lines of chat, and the script is specifically made to work wiht that.

It replaces strings in the SVG file and renders it out using ImageMagick to a transparent PNG sequence.

If you then inmport that sequence with FPS value of 1, you'll have an animated IRC chat replay ready to use in a video.

You can customize the SVG template to suit your needs, change the fonts, number of lines, layout etc. - though if you change the line amount, you'll need to modify the script too.

The IRC parsing is very basic and only works properyl with user messages - channel messages like leave/join will break it, so I just removed them manually in the IRC log.
