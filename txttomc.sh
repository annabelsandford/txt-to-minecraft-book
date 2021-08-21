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
# 1.0.0

# Declarations >>

author="Annabel Sandford" # Author of this abomination (me)
progver="1.0.0" # Version number, also for the UI
progname="TXT to Minecraft Book & Quill" # Name of the script, for the UI
usagedir=$HOME/Desktop/Bible # The working directory of this script. >> SAVE TXT's HERE <<
configfile=$usagedir/config.baq # Configuration File Path
usagedir_length=${#usagedir} # Count the length of working directory above. Needed later on.
usagedir_length=$((usagedir_length+2)) # Increment length from before because somehow it's wrong by 2. Don't ask me why.
file_format=".txt" # Also self explanatory
break_txt="*.txt" # String I need in list() to determine empty directory

maxchar=230 # Maximum Character Cap per Page in Minecraft. Do not change.
maxpage=100 # Maximum Page Cap per Book in Minecraft. Also don't change. Or do if you're feeling adventurous.
start_timer=5 # Timer until script kicks in after initializing it
bookmin=1 # Minimum of books a document can take up
pagetotal=0 # Set variable to count for total pages later on. It'll make more sense later.

# Internal Declarations >>
checkletters=[^a-zA-Z] # Letters for the Word Detection
mousetimer=0 # I don't feel like explaining it
worddetect=0 # Variable for Word Detection. Every time the script detects the character it's cutting off next is within a word, this goes up

mkdir -p $usagedir #Check if working directory exists, create if not

if [[ ! -e $configfile ]]; then # after direcory check if config file exists
    touch $configfile # if config file doesn't exit, create
    echo $maxchar"\n"$maxpage"\n"$start_timer > $configfile # write variables to config file
fi

original_maxchar=$maxchar
original_maxpage=$maxpage
original_start_timer=$start_timer

# Functions >>
read_config() {
  config_maxchar=`echo | awk 'NR==1 {print;exit}' $configfile`
  config_maxpage=`echo | awk 'NR==2 {print;exit}' $configfile`
  config_start_timer=`echo | awk 'NR==3 {print;exit}' $configfile`
  maxchar=$config_maxchar
  maxpage=$config_maxpage
  start_timer=$config_start_timer
}

check_connection() {
  echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

  if [ $? -eq 0 ]; then
      echo "Online"
  else
      echo "No Internet Connection."
      exit
  fi
}

prerequisites() {
  clear
  line
  echo "Prerequisites Check (1/3)"
  echo "Check for: Homebrew"
  line
  if [[ $(command -v brew) == "" ]]; then
      echo "Installing Homebrew..."
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
      echo "Homebrew installed..."
      sleep 0.5
  fi
  prerequisites_1
}
prerequisites_1() {
  clear
  line
  echo "Prerequisites Check (2/3)"
  echo "Check for: Cliclick"
  line
  if [[ $(command -v cliclick) == "" ]]; then
      echo "Installing Cliclick..."
      brew install cliclick
  else
      echo "Cliclick installed..."
      sleep 0.5
  fi
  prerequisites_2
}
prerequisites_2() {
  clear
  line
  echo "Prerequisites Check (3/3)"
  echo "Check for: gnu-sed"
  line
  if [[ $(command -v gsed) == "" ]]; then
      echo "Installing gnu-sed..."
      brew install gnu-sed
  else
      echo "gnu-sed installed..."
      sleep 0.5
  fi
}

line() { # A function to create these lines because I can't be bothered to CMD+C / CMD+V this shit
  echo "==============================="
}

newline() { # A function to create new lines because why not
  echo " "
}

settings() {
  read_config
  clear
  echo "$progname $progver\nWritten by: $author"
  line
  echo "Loc: ../Start/Settings"
  line
  echo "Max. Character Value (Characters per Page):"
  echo "_maxchar: "$maxchar
  if [ "$maxchar" -ne "$original_maxchar" ]; then
    echo "$(tput setaf 1)$(tput setab 7)>> CAUTION: Recommended value shall not exceed 230 characters$(tput sgr 0)"
  fi
  newline
  echo "Max. Pages Value (Pages used per Book):"
  echo "_maxpage: "$maxpage
  if [ "$maxpage" -ne "$original_maxpage" ]; then
    echo "$(tput setaf 1)$(tput setab 7)>> CAUTION: Recommended value shall not exceed 100 pages.$(tput sgr 0)"
  fi
  newline
  echo "Start Timer Value (Timer until script starts writing):"
  echo "_start: "$start_timer
  if [ "$start_timer" -ne "$original_start_timer" ]; then
    echo "$(tput setaf 1)$(tput setab 7)>> Original Value: $original_start_timer$(tput sgr 0)"
  fi
  newline
  line
  echo "1 to edit maxchar / 2 to edit maxpage / 3 to edit timer"
  echo "Press C to go back / Enter 'reset' to reset values"
  read settingsenter
  settingsenter=$(echo $settingsenter | tr 'A-Z' 'a-z') # Convert user input into lowercase for accessibility
  if [ "$settingsenter" = "c" ]; then # Check if userinput was C. If yes then..
    list
  elif [ "$settingsenter" = "1" ]; then # Check if userinput was 1. If yes then..
    newline
    echo "Enter new MaxChar value (old:) "$maxchar
    read maxcharedit
    maxcharedit="${maxcharedit//[[:space:]]/}"
    if [[ $maxcharedit =~ ^[0-9]+$ ]]
    then
     echo ">> Valid ("$maxcharedit")"
     gsed -i '1s/.*/'$maxcharedit'/' $configfile
     sleep 1
     settings
    else
     echo ">> Invalid"
     sleep 2
     settings
    fi
  elif [ "$settingsenter" = "2" ]; then # Check if userinput was 2. If yes then..
  newline
  echo "Enter new MaxPage value (old:) "$maxpage
  read maxpageedit
  maxpageedit="${maxpageedit//[[:space:]]/}"
  if [[ $maxpageedit =~ ^[0-9]+$ ]]
  then
   echo ">> Valid ("$maxpageedit")"
   gsed -i '2s/.*/'$maxpageedit'/' $configfile
   sleep 1
   settings
  else
   echo ">> Invalid"
   sleep 2
   settings
  fi
  elif [ "$settingsenter" = "3" ]; then # Check if userinput was 3. If yes then..
  newline
  echo "Enter new StartTimer value (old:) "$start_timer
  read starttimeredit
  starttimeredit="${starttimeredit//[[:space:]]/}"
  if [[ $starttimeredit =~ ^[0-9]+$ ]]
  then
   echo ">> Valid ("$starttimeredit")"
   gsed -i '3s/.*/'$starttimeredit'/' $configfile
   sleep 1
   settings
  else
   echo ">> Invalid"
   sleep 2
   settings
 fi
  elif [ "$settingsenter" = "reset" ]; then # Check if userinput was 3. If yes then..
    gsed -i '1s/.*/230/' $configfile
    gsed -i '2s/.*/100/' $configfile
    gsed -i '3s/.*/5/' $configfile
    echo ">> Reset Values"
    sleep 1
    settings
  else
    settings
  fi
}

process_check() { # Get Minecraft Process ID (PID). Blatantly recycled from an old project of mine.
  minecraft_pid=$(osascript -e 'tell application "System Events"
  if application process "java" exists then
  tell application "System Events"
  return the unix id of (every process whose name contains "java")
  end tell
  else
  return "NO-PID"
  end if
  end tell') # Runs an AppleScript above to get the PID and saves it as a shell variable
  clear # Clear screen. Probably not necessary. Do it anyways.
  if [ $minecraft_pid = "NO-PID" ] ; then
    echo "$progname $progver\nWritten by: $author"
    line
  	echo "No Minecraft Process could be found."
  	echo "Please start Minecraft first."
  	read -n 1 -r -s -p $'Press any key to continue...\n'
  	exit # Quit if no Minecraft process could be found
  else
    echo "$progname $progver\nWritten by: $author"
    line
  	echo "Minecraft Process ID: $minecraft_pid"
  	read -n 1 -r -s -p $'Press any key to continue...\n' # Continue if there actually is a Minecraft process.
  fi
}

list() { # List all files from working directory
totalincrement=1
clear
echo "$progname $progver\nWritten by: $author"
line
echo "Loc: ../Start"
line
echo "Text Files (.txt):\n"
  for entry in "$usagedir"/*.txt # for each TXT file in working directory
  do
    cut_entry=$(echo $entry | cut -c$usagedir_length-) # Cut off the directory path - Only leave file names.
    if [ "$cut_entry" = "$break_txt" ]; then # If file name equals to break_txt (empty list) then...
    echo "There are no files."
    echo "Please move .txt files into $usagedir"
    newline
    exit # quit
  else # When there are files do...
    echo "($totalincrement)> $cut_entry"
    totalincrement=$((totalincrement + 1))
  fi
  done

  newline
  echo "Please enter filename (eg. test.txt) to continue"
  echo "C to quit / R to reload / S to settings"
  read userfilename
  userfilename=$(echo $userfilename | tr 'A-Z' 'a-z') # Convert user input into lowercase for accessibility
  if [ "$userfilename" = "c" ]; then # Check if userinput was C. If yes then..
    echo "See ya!"
    exit # .. Quit.
  elif [ "$userfilename" = "r" ]; then # If the input was R, go back to list() (reload)
  echo "Reloading.."
  sleep 0.5
  list
elif [ "$userfilename" = "s" ]; then # If the input was S, go back to settings()
settings
  else
    userfilename=${userfilename//$file_format/} # Remove potential file extention entered by user
    userfilename=$userfilename$file_format # Append file extention
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
    echo "Do you want to continue with $compfile?\nThere's no going back.\n"
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
  #tr -d '\n' < $compfile
  total_chars=$(wc -c < $compfile)
  total_chars=$(echo ${total_chars//[[:blank:]]/})
  approx_pages=$((total_chars / maxchar))
  approx_books=$((approx_pages / maxpage))
  approx_books=$((approx_books + 1)) # Somehow it's required. Don't ask why. I've found out thru extensive testing. Trust me.

  echo "$userfilename has $total_chars characters."
  echo "$userfilename would take up $approx_pages pages."
  echo "$userfilename would need $approx_books books."
  newline
  echo "Press Y to continue / Press C to cancel"
  read textworkinput2 # Wait for user input (Preferably Y or C) we know the drill
  textworkinput2=$(echo $textworkinput2 | tr 'A-Z' 'a-z') # Convert user input into lowercase for accessibility. 3rd time.
  if [ "$textworkinput2" = "y" ]; then # If the input was Y, continue
    textwork3
  elif [ "$textworkinput2" = "c" ]; then # If the input was C, go back to list()
    list # Why list() instead of just going back? Because I wanna be a subtle pain in the ass. That's why.
  else # If the user entered something completely stupid, restart textwork2(). Like before.
    echo "Unknown Command."
    echo "Please try again"
    textwork2
  fi
}

textwork3() {
  entire_file="$(cat $compfile)" # Put the entire .txt file into a string
  entire_file=$(echo $entire_file | tr -d '\r') # Remove newlines because it fucks up the script yo
  prev_books=$((i - 1))
  sleep 2
  for ((i=1;i<=approx_books;i++)); do # Until required amount of books is reached, do..
  clear # Clear screen and stuff
  if [ "$i" -ne 1 ]; then
    echo "WRITTEN BOOK: $prev_books"
  fi
  echo "This is Book $i / $approx_books of $userfilename"
  line
  echo "Please open a Book & Quill. Place your cursor on the right page arrow."
  echo "Press Y to continue / Press C to cancel"
  read textworkinput3 # Wait for user input
  textworkinput3=$(echo $textworkinput3 | tr 'A-Z' 'a-z') # Convert user input into lowercase.
  if [ "$textworkinput3" = "y" ]; then # input was Y, continue

  for ((it=0;it<=start_timer;it++)); do
    clear
    echo "Book $i / $approx_books of $userfilename"
    echo "Timer until script starts:"
    line
    echo "$it / $start_timer"
    sleep 1
  done

  # << WRITE TEXT TO MINECRAFT START

  for ((ia=1;ia<=maxpage;ia++)); do # Repeat until maximum page cap is reached..

  check_checker="NO LETTER"
  maxchar_new=$maxchar
  next_char_check=$(echo $entire_file | cut -c $maxchar)
  if [[ "$next_char_check" =~ ^[0-9a-zA-Z]+$ ]]; then
    check_checker=">> LETTER DET. / EXPANDING"
    while [[ "$next_char_check" =~ ^[0-9a-zA-Z]+$ ]]; do
      maxchar_new=$((maxchar_new+1))
      worddetect=$((worddetect+1))
      check_checker=">> LETTER DET. / EXPANDING / WHILE"
      next_char_check=$(echo $entire_file | cut -c $maxchar_new)
    done
  fi

  page_to_write=$(echo $entire_file | head -c $maxchar_new) # Put the first maximum characters of entire_file into a variable
  if [[ -n "${page_to_write/[ ]*\n/}" ]]
  then
    clear
    echo "DEBUG! (Please ignore)\n_MAXCHAR_NEW: $maxchar_new\n_MAXCHAR: $maxchar\nCheck: $check_checker"
    line
    echo "Page $ia / $maxpage - Book $i"
    line
    page_to_write=${page_to_write//$'\r'}
    page_to_write=${page_to_write//$'\n'}
    echo "$page_to_write"
    echo "$page_to_write" | pbcopy # Give us those characters and copy to clipboard
    newline
    # << MINECRAFT WRITE PAGE APPLESCRIPT START

    osascript -e 'tell application "System Events" to keystroke (the clipboard)'
    sleep 1.5
    cliclick c:.
    # >> MINECRAFT WRITE PAGE APPLESCRIPT START

    entire_file=${entire_file:$maxchar_new} # Delete them from the entire_file string
  else
    break
  fi
  done

  # >> WRITE TEXT TO MINECRAFT END

  elif [ "$textworkinput3" = "c" ]; then # input was C, go back to list()
    list
  else
    echo "Unknown Command."
    echo "Please try again"
    textwork2
  fi
  done
  book_fully_cooked_aye
}

book_fully_cooked_aye() {
  echo "$userfilename done."
  line
  newline
  echo "Press Y to go back / Press C to quit"
  read textworkinput4
  textworkinput2=$(echo $textworkinput2 | tr 'A-Z' 'a-z')
  if [ "$textworkinput2" = "y" ]; then
    list
  elif [ "$textworkinput2" = "c" ]; then
    exit
  else
    echo "Unknown Command."
    echo "Please try again"
    book_fully_cooked_aye
  fi
}

# Start >>
read_config
clear
prerequisites
clear
# process_check << DEBUG! Reactivate later. If I forgot to do it then I'm legally blind.
list
echo "If you see this, something went super-duper wrong. You shouldn't be able to see this."
# The End <3
