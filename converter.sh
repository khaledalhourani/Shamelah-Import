#!/bin/bash
# shamela Convert Script

# Start timer to measure how much time the script consume
START=$(date +%s)


PATH=/bin:/usr/bin:/usr/local/bin:/usr/local/ssl/bin:/usr/sfw/bin ; export PATH

# Export as SQL by default (cmdline: -s)
SQL="TRUE"

# Don't export as CSV by default (cmdline: -c)
CSV="FALSE"


##########################################
# Purpose: Describe how the script works
# Arguments:
#   Filename
##########################################
usage()
{
  echo "Program: $0"
  echo "Usage: $0 -s -c filename"
  echo ""
  echo "  -s  : Export as SQL"
  echo "  -c  : Export as CSV file"
  echo ""
}


### Evaluate the options passed on the command line
while getopts sc OPTION
do
  case "${OPTION}"
  in
    s) SQL="TRUE";;
    c) CSV="TRUE";;
    \?) usage
    exit 1;;
  esac
done


convert()
{
  BASENAME=$(basename $FILE)
  FILENAME=${BASENAME%.*}

  DIR=$(dirname $FILE)
  DIRNAME=$DIR/$FILENAME
  mkdir $DIRNAME

  len=${#TABLES[@]};

  i=0
  while (( $i < $len ))
  do
    if [ ${SQL} == "TRUE" ]
    then
      #mdb-schema $FILE > $DIR/${TABLES[i]}_schema.sql
      mdb-export -R ';\n' -I $FILE ${TABLES[i]} > $DIRNAME/${TABLES[i]}.sql
    fi

    #if [ ${CSV} == "TRUE" ]
    #then
      #mdb-export $FILE ${TABLES[i]} > $DIRNAME/${TABLES[i]}.csv
    #fi
    (( i++ ));
  done
}


# First set env variables
export MDB_ICONV=utf-8
export MDB_JET3_CHARSET=cp1256

# Catch arguments
FILE=$1


# is the passed file exist?
if [ -f $FILE ]
then
  # Get tables from the file
  TABLES=`mdb-tables $FILE`
  # and convert the string output of mdb-tables into array
  OLD_IFS="$IFS"
  IFS=" "
  TABLES=( $TABLES )
  IFS="$OLD_IFS"
  # then call convert function
  convert $TABLES
else
  echo "File $FILE not found!"
  exit 1
fi


# End timer and calculate the difference between START and END
END=$(date +%s)
DIFF=$(( $END - $START ))


# Display execution time
echo "Success: It took $DIFF seconds" 

