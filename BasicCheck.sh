#!/bin/bash

# initialize vairabels 
CMP="Fail"
VLG="Fail"
HLG="Fail"

CMPBIT=4
VLGBIT=2
HLGBIT=1

DIRPATH=$1
PROGNAME=$2

# check if there is makeFile in 'dir path'
# egrep is regex for return '0' or '1'
cd $DIRPATH
if(find ./ -name "Makefile" | egrep '.*')

then
    if(make) # check if compilation passed
    then
        CMP="Pass"
        CMPBIT=0
     # ./a.out # Option for run the program
    
    valgrind --leak-check=full -v ./$PROGNAME chmod a+x > Valgrind.txt 2>&1 # memory leaks check,chmod a+x- gives permission

     if(grep -q "ERROR SUMMARY: 0 errors" "Valgrind.txt") # check valgrind result
    then
        VLG="Pass"
        VLGBIT=0
     fi
    
    valgrind --tool=helgrind ./$PROGNAME > Helgrind.txt 2>&1 # check thread race
   
     if(grep -q "ERROR SUMMARY: 0 errors" "Helgrind.txt") # check helgrind result
    then
        HLG="Pass"
        HLGBIT=0
     fi
     
     fi

fi
    # print the results 
     echo "Compilation\tMemory leaks\tthread race"
     echo $CMP "\t\t" $VLG "\t\t" $HLG 

Total=$(($HLGBIT+$VLGBIT+$CMPBIT))
exit $Total
