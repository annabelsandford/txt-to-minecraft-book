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

maxchar=266 # Maximum Character Cap per Page in Minecraft. Do not change.
maxpage=999 # Maximum Page Cap per Book in Minecraft. Also don't change. Or do if you're feeling adventurous.
pagetotal=0 # Set variable to count for total pages later on. It'll make more sense later.

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
    sleep 0.5
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
  echo "$compfile"
  
}

# Start >>
clear
list

# The End <3
