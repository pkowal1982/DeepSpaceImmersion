## Deep Space Immersion

**Deep Space Immersion** is a simple game and test project for using webcam on Linux with **[Godot Engine](https://godotengine.org)**.  
It aims at tracking your head without any special gear, also trying to make it fast and cheap, so it can run on older hardware.
To achieve this goal it's tracking a DIY marker attached to your head, allowing to dive into the game world.

![Screenshot of a running game](https://raw.githubusercontent.com/pkowal1982/deepspaceimmersion/master/production/screenshot.jpg)

## Testing

You can download exported game for Ubuntu/Windows from [itch.io](https://pkowal1982.itch.io/deep-space-immersion), only Linux version supports head tracking.

But if you know what your doing:

1. Download Godot 4.4 dev 3 version.

2. Download [this project](https://github.com/pkowal1982/DeepSpaceImmersion/archive/refs/heads/master.zip)
and open it with Godot Engine editor you've already downloaded.

3. Get yourself a marker. It can be color sticky note, pin-pong ball or you can print
black and white one from the [file provided.](https://github.com/pkowal1982/DeepSpaceImmersion/blob/master/image/markers.svg).

4. Run project, have fun, report problems if any. :)
You can run Godot Engine editor with verbose switch which will print additional diagnostic information:  
`$ ./godot.linuxbsd.tools.64 --verbose`

## Markers

**Deep Space Immersion** aims at tracking your head without any special gear and making it fast and cheap,
so it can run on older hardware.
You can try to use color sticker note or ping-pong ball. Notes are easier to attach but tend to change
their color when tilted so balls can prove a better alternative.

Choose marker with contrasting color, green and blue will do nicely, assuming you don't have anything
that color in the background.

If you do not have color marker you can try black and white one.
Print the [provided file](https://github.com/pkowal1982/DeepSpaceImmersion/blob/master/image/markers.svg)
and depending on your camera setup choose the one best working. Remember tracking bw marker is more expensive.

## Gameplay on YouTube:

[![Short game preview](https://img.youtube.com/vi/79QHXEGs4DY/0.jpg)](https://youtu.be/79QHXEGs4DY)
