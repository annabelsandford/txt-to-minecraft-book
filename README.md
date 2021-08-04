# TXT to Minecraft Book & Quill

A Shell script written on macOS to import any *.txt file into a Minecraft Book. 

The goal of this script is to determine how many Books are needed to import any given *.txt file into Minecraft. This is achieved by following Minecraft's strict character and page limitations. 

## Prerequisites

1. xdotool
2. macOS Catalina 10.15 (or higher) because the script probably needs adjustments for Bash 3.0 (10.14 and below). If you can get it to run tho it should even run on OS X 10.5 / PowerPC. Though you might face problems running Minecraft then. You do you.
3. AppleScript is being used too, though I cannot say whether the syntax and functions being used works on versions below 10.15. You might have to try it out / tweak it.

_I might work on a Python version in the future. Until then: No Windows support. Go get Linux._

## Installation

1. Download & install _xdotool_ by running the command below in Terminal
2. ```bash
3. brew install xdotool
4. ```
3. Download [txttomc.sh](https://choosealicense.com/licenses/mit/)
4. Run via Terminal

## Modifying
I have made a serious effort to declare as many dynamic variables in the beginning as possible, making it easier to tweak & play around with the script.

_If you happen to modify the code, you can change the author name used in the UI here. Not recommended. Why? Because I'm the author. Not you. Please don't change. For the love of god._
```bash
author="Annabel Sandford" # Author of this abomination (me)
```
_Version Number. Always equivalent to the one used on GitHub_
```bash
progver="0.0.1" # Version number, also for the UI
```
_You are also able to change the name of the program used in the UI here. I'm not sure why anyone would do that though._
```bash
progname="TXT to Minecraft Book & Quill" # Name of the program, for the UI
```
_Here it gets interesting. You can change the working directory of the program here. It normally takes your user directory ($HOME) and appends /Desktop/Bible to it. You can change it to whatever you like. At Line 47 the mkdir code checks if usagedir exists, if not, creates it. You can remove the check without any problems as long as you make sure the folder exists._
```bash
usagedir=$HOME/Desktop/Bible # The working directory of this program. >> SAVE TXT's HERE <<
```
_The break_txt string is being used to check for an empty working directory. Only *.txt's count as files, everything else is being ignored._
```bash
break_txt="*.txt" # String I need in list() to determine empty directory
```
_Minecraft's Maximum Character Cap per page (1.17.1). The script cuts the given *.txt files into pieces using maxchar. If Mojang decides to change the Character Cap per page you can update / adjust it here if not done already._
```bash
maxchar=266 # Maximum Character Cap per Page in Minecraft. Do not change.
```
_Minecraft's Maximum Page Cap per book (1.17.1). The script cuts the given *.txt files into pieces using maxchar. If Mojang decides to change the Character Cap per page you can update / adjust it here if not done already._
```bash
maxpage=999 # Maximum Page Cap per Book in Minecraft. Also don't change. Or do if you're feeling adventurous.
```
_Internal page counting variable so the program can tell if it hit the maxpage limit. Important if a *.txt is over the maxpage limit so it can continue with a different Book & Quill afterwards. Don't change the value if you have an IQ over 30._
```bash
pagetotal=0 # Set variable to count for total pages later on. It'll make more sense later.
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
