#!/bin/sh
#                    _
#                ,="` `""=,       o
#               /   ,=="""'=;        , __
#       ~      /      ,--'/=,)  o    \`\\"._     _,
#             |   .='/ <9(9.="       / _  |||;._//)
#            /     (J    ^\ \     o_/@ @  ///  |=(
#          .'    .' \  '='/  '-.  ( (`__,     ,`\|
#         /     /    \`-;_      \  '.\_/ |\_.'
#    ~   /      |   /` _  \      )   `""```
#       | ,     ;  /`\/ `\ \    /.-._///_
#       |/     '   \_,\__/\ \.-'.'----'`
#        \|     '.   \     \   /`-,   ~
#          `\     _.-'\    (`-`  .'
#            `-.-' _.-')__./,--'
#         .--'`,-'`'""`    ` \
#        /`"`-`               |          ~
#       |                     /
#    ~  |     .-'__         .'
#        \   ;'"`  `""----'`
#         \   \
#          '.  `\
#            )   `-.            ~
#           /       `-._
#          |     ,      `-,
#       ~  \   .' `''----`
#           `.(
#             `
# Written by Annabel Sandford (@annabellica / @joyeuserie) 2021
# TXT to Minecraft Book & Quill Project
# 0.0.1

# Declarations >>

author="Annabel Sandford" # Author of this abomination (me)
progver="0.0.1" # Version number, also for the UI
progname="TXT to Minecraft Book & Quill" # Name of the program, for the UI
usagedir=$HOME/Desktop/Bible # The working directory of this program. >> SAVE TXT's HERE <<
usagedir_length=${#usagedir} # Count the length of working directory above. Needed later on.
usagedir_length=$((usagedir_length+2)) # Increment length from before because somehow it's wrong by 2. Don't ask me why.
break_txt="*.txt" # String I need in list() to determine empty directory

maxchar=255 # Maximum Character Cap per Page in Minecraft. Do not change.
maxpage=100 # Maximum Page Cap per Book in Minecraft. Also don't change. Or do if you're feeling adventurous.
bookmin=1 # Minimum of books a document can take up
pagetotal=0 # Set variable to count for total pages later on. It'll make more sense later.

# Internal Declarations >>
mousetimer=0 # I don't feel like explaining it

mkdir -p $usagedir #Check if folder exists, create if not

# Functions >>

line() { # A function to create these lines because I can't be bothered to CMD+C / CMD+V this shit
  echo "==============================="
}

newline() { # A function to create new lines because why not
  echo " "
}

list() { # List all files from working directory
clear
echo "$progname $progver\nWritten by: $author"
line
echo "Files:"
  for entry in "$usagedir"/*.txt # for each TXT file in working directory
  do
    cut_entry=$(echo $entry | cut -c$usagedir_length-) # Cut off the directory path - Only leave file names.
    if [ "$cut_entry" = "$break_txt" ]; then # If file name equals to break_txt (empty list) then...
    echo "There are no files."
    echo "Please move .txt files into $usagedir"
    newline
    exit
  else # When there are files do...
    echo "> $cut_entry"
  fi
  done
  newline
  echo "Please enter filename (eg. test.txt) to continue"
  echo "Alternatively enter C to quit"
  read userfilename
  userfilename=$(echo $userfilename | tr 'A-Z' 'a-z') # Convert user input into lowercase for accessibility
  if [ "$userfilename" = "c" ]; then # Check if userinput was C. If yes then..
    echo "See ya!"
    exit # .. Quit.
  else
    textwork # If it wasn't C, continue.
  fi
}

textwork() {
  clear
  compfile="$usagedir/$userfilename" # Take userinput (userfilename) and append to working directory
  echo "$compfile" # DEBUG
  if [ -f "$compfile" ]; then # Check if user input exists, if yes...
    echo "$userfilename exists." # Tell us it exists.
    newline
    sleep 0.1 # Before you judge me for sleeping for 0.1 second = My computer is slow. I need to give it a lil time
    echo "Please open Minecraft, then equip a Book & Quill."
    echo "Press Y to continue / Press C to cancel"
    read textworkinput1 # Wait for user input (Preferably Y or C), store in variable textworkinput1
    textworkinput1=$(echo $textworkinput1 | tr 'A-Z' 'a-z') # Convert user input into lowercase for accessibility. Again.
    if [ "$textworkinput1" = "y" ]; then # If the input was Y, continue
      textwork2
    elif [ "$textworkinput1" = "c" ]; then # If the input was C, go back to list()
      list
    else # If the user entered something completely stupid, restart textwork()
      echo "Unknown Command."
      echo "Please try again"
      sleep 3
      textwork
    fi
  else # If entered file does not exist...
    echo "$userfilename does not exist." # Tell us it does not exist.
    line # Draw a neat line
    echo "Going back..." # Give the user feedback, tell 'em what's gonna happen
    sleep 3 # Wait for 3 seconds
    list # Go back to list()
  fi
}

textwork2() {
  clear
  echo "Counting Characters of $userfilename ..."
  sleep 0.1 # Don't judge it's for compatibility reasons
  line
  total_chars=$(wc -c < $compfile)
  total_chars=$(echo ${total_chars//[[:blank:]]/})
  approx_pages=$((total_chars / maxchar))
  approx_books=$((approx_pages / maxpage))

  echo "$userfilename has $total_chars characters."
  echo "$userfilename would take up $approx_pages pages."
  echo "$userfilename would need $approx_books books."
  newline
}

# Start >>
clear
# Get Minecraft Process ID (PID)
minecraft_pid=$(osascript -e 'tell application "System Events"
if application process "java" exists then
tell application "System Events"
return the unix id of (every process whose name contains "java")
end tell
else
return "NO-PID"
end if
end tell') # Runs an AppleScript to get the PID and saves it as a shell variable
Clear
if [ $minecraft_pid = "NO-PID" ] ; then
  echo "$progname $progver\nWritten by: $author"
  line
	echo "No Minecraft Process could be found."
	echo "Please start Minecraft first."
	read -n 1 -r -s -p $'Press enter to continue...\n'
	exit
else
  echo "$progname $progver\nWritten by: $author"
  line
	echo "Minecraft Process ID: $minecraft_pid"
	read -n 1 -r -s -p $'Press enter to continue...\n'
fi
list

# The End <3
