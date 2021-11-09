#!/bin/bash

# Date of birth
BORN_Y=2000
BORN_M=1
BORN_D=1
# End dates for each stage of life (incl. holidays)
EARLY_YEARS_Y=2007
EARLY_YEARS_M=8
EARLY_YEARS_D=31
ELEMENTARY_SCHOOL_Y=2015
ELEMENTARY_SCHOOL_M=8
ELEMENTARY_SCHOOL_D=31
MIDDLE_SCHOOL_Y=2020
MIDDLE_SCHOOL_M=8
MIDDLE_SCHOOL_D=31
HIGH_SCHOOL_Y=2025
HIGH_SCHOOL_M=9
HIGH_SCHOOL_D=30
CAREER_Y=2066
CAREER_M=12
CAREER_D=31

# Do not modify below this line
FILE="weeks.html"
WEEKS_COUNT=0

# Prints number of weeks from the date given as parameter YYYY MM DD till now or till the date given as the
# second set of YYYY MM DD.
function weeks_from_date() {
  YEAR=$1
  MONTH=$2
  DAY=$3
  if [ -n $4 ] && [ -n $5 ] && [ -n $6 ]; then
    YEAR_FROM=$4
    MONTH_FROM=$5
    DAY_FROM=$6
    from=$(date +%s --date "$YEAR_FROM-$MONTH_FROM-$DAY_FROM")
  else
    from=$(date +%s)
  fi
  to=$(date +%s --date "$YEAR-$MONTH-$DAY")
  difference=$(($from - $to))

  echo $(($difference / (3600 * 24 * 7)))
}

TODAY_WEEK_NO=$(weeks_from_date $BORN_Y $BORN_M $BORN_D)
echo TODAY_WEEK_NO $TODAY_WEEK_NO
EARLY_YEARS_WEEK_NO=$(weeks_from_date $BORN_Y $BORN_M $BORN_D $EARLY_YEARS_Y $EARLY_YEARS_M $EARLY_YEARS_D)
echo EARLY_YEARS $EARLY_YEARS_WEEK_NO
ELEMENTARY_SCHOOL_WEEK_NO=$(weeks_from_date $EARLY_YEARS_Y $EARLY_YEARS_M $EARLY_YEARS_D $ELEMENTARY_SCHOOL_Y $ELEMENTARY_SCHOOL_M $ELEMENTARY_SCHOOL_D)
ELEMENTARY_SCHOOL_WEEK_NO=$(($ELEMENTARY_SCHOOL_WEEK_NO + $EARLY_YEARS_WEEK_NO))
echo ELEMENTARY_SCHOOL $ELEMENTARY_SCHOOL_WEEK_NO
MIDDLE_SCHOOL_WEEK_NO=$(weeks_from_date $ELEMENTARY_SCHOOL_Y $ELEMENTARY_SCHOOL_M $ELEMENTARY_SCHOOL_D $MIDDLE_SCHOOL_Y $MIDDLE_SCHOOL_M $MIDDLE_SCHOOL_D)
MIDDLE_SCHOOL_WEEK_NO=$(($MIDDLE_SCHOOL_WEEK_NO + $ELEMENTARY_SCHOOL_WEEK_NO))
echo MIDDLE_SCHOOL $MIDDLE_SCHOOL_WEEK_NO
HIGH_SCHOOL_WEEK_NO=$(weeks_from_date $MIDDLE_SCHOOL_Y $MIDDLE_SCHOOL_M $MIDDLE_SCHOOL_D $HIGH_SCHOOL_Y $HIGH_SCHOOL_M $HIGH_SCHOOL_D)
HIGH_SCHOOL_WEEK_NO=$(($HIGH_SCHOOL_WEEK_NO + $MIDDLE_SCHOOL_WEEK_NO))
echo HIGH_SCHOOL $HIGH_SCHOOL_WEEK_NO
CAREER_WEEK_NO=$(weeks_from_date $HIGH_SCHOOL_Y $HIGH_SCHOOL_M $HIGH_SCHOOL_D $CAREER_Y $CAREER_M $CAREER_D)
CAREER_WEEK_NO=$(($CAREER_WEEK_NO + $HIGH_SCHOOL_WEEK_NO))
echo CAREER $CAREER_WEEK_NO

echo "<!DOCTYPE html>" >> $FILE
echo "<html>" >> $FILE
echo "<head>" >> $FILE
echo "<link rel='stylesheet' type='text/css' href='style.css'>" >> $FILE
echo "</head>" >> $FILE
echo "<table>" >> $FILE
for y in {1..88}; do
  echo "<tr><td>$y</td>" >> $FILE
  for w in {1..52}; do
    ((WEEKS_COUNT++))
    if [ $WEEKS_COUNT -le $TODAY_WEEK_NO ]; then
      CHECKED="checked disabled='true'"
    else
      CHECKED=""
    fi

    if [ $WEEKS_COUNT -le $EARLY_YEARS_WEEK_NO ]; then
      STYLE="early_years"
    elif [ $WEEKS_COUNT -le $ELEMENTARY_SCHOOL_WEEK_NO ]; then
      STYLE="elementary_school"
    elif [ $WEEKS_COUNT -le $MIDDLE_SCHOOL_WEEK_NO ]; then
      STYLE="middle_school"
    elif [ $WEEKS_COUNT -le $HIGH_SCHOOL_WEEK_NO ]; then
      STYLE="high_school"
    elif [ $WEEKS_COUNT -le $CAREER_WEEK_NO ]; then
      STYLE="career"
    else
      STYLE="retirement"
    fi
    echo "<td id='$STYLE'><input type='checkbox' id='y$y.w$w' name='y$y.w$w' $CHECKED></td>" >> $FILE
  done
  echo "</tr>" >> $FILE
done
echo "</table>" >> $FILE
echo "</html>" >> $FILE
