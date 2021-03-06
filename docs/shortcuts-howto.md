I've tried to add the ability to customize your NixNote menu shortcuts,
but I don't want to take the time to setup a new dialog box and all the
junk that entails.  So, I chose a text file config instead.  Eventually I 
may change it so the text file can be edited within the running program, but
I have other things to spend my time on at the moment.

First, you don't need to do this.  Nixnote comes with a default set of 
shortcuts.  If you are happy with those then you don't need to do a thing.

If you want to customize your shortcuts then you need to do a little work.

You should have a /usr/share/nixnote2/shortcuts.txt file.
(Note if you use AppImage, you need to unpack it first to get the contents
- e.g. ./NixNote2.AppImage --appimage-extract - see 
https://github.com/robert7/nixnote2/wiki/HowTo---Run-AppImage-without-FUSE)*[]: 

Copy this to shortcuts.txt
in your Nixnote config directory (see menu Help/Data and log location info).
This is the file that is read when Nixnote starts.
Any changes to this file only happen at startup
so if you change it you need to restart the program to see those changes.

This file has three main columns.  

The first column is the menu item you are wanting to trigger with the
shortcut.  For example, File_Note_Add is the shortcut to add a note and
Tools_Connect is the shortcut under the tools menu to connect.

The second column is the shortcut sequence.  For example, "Ctrl+N" or
"F10" or "Ctrl+Shift+F12".  

The remainder of the line is comments and comments should begin
with // characters.  Spaces or tabs are treated as delimiters.

When editing the file, you must have at least the first column (i.e.
File_Note_Add).  If you do not put anything else on that line or 
if you just have comments on the rest of the line you will be 
removing that shortcut.  For example, a line like this will cause 
the shortcut to add a note to be removed.

File_Note_Add              // Remove that shortcut

If you want to change a shortcut, then put the shortcut sequece.  For example, 
this line would change the note add shortcut to Ctrl+W

File_Note_Add    Ctrl+W    // Add shortcut

If you choose a shortcut key sequence that already exists in the it will 
remove that default shortcut and assign it to your custom shortcut.  If
you put the same shortcut twice or the same action twice with two
different shortcuts, the last one will be the one used.

In you shortcuts.txt you only need to put the shortcuts you want
changed.  Any action not in that file will use the default shortcut (or
will use the default of no shortcut).  It doesn't hurt to use the 
complete sample shortcut file, but I'd recommend only having the shortcuts
you want changed in shortcuts.txt.  It will probably make it easier in the
long run for you to support if I add other shortcuts later.

Good luck.
