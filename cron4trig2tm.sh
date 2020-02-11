#! /bin/bash
export CAMPSITES_ROOT="/opt/www/101camp"
#echo $DU19SRC_ROOT
#source /home/du19/.bashrc
#=========================================================== var defines
VER="cron4trig2tm.sh v.200211.1742"
DATE=`date "+%y%m%d"`
#NOW=$(date +"%Y-%m-%d")
PYENV=$( which pyenv)

PBIN=/home/du19/.pyenv/versions/du380/bin
PY=$PBIN/python
PIP=$PBIN/pip
ACTI=$PBIN/activate
#=========================================================== path defines
YEAR=`date +"%Y"`
MONTH=`date +"%m"`
NOW=`date +"%y%m%d_%H%M%S"`

AIMP=/opt/log/cron
#LOGF=$AIMP/$YEAR-$MONTH-YAtrigger.log
LOGP=$COMM/$YEAR/$MONTH
LOGF=$LOGP/$NOW-tm.log
#=========================================================== action defines
echo $LOGP
echo $LOGF
mkdir -p $LOGP

#=========================================================== action defines
export CAMP_TM=/opt/www/101camp/TM
#echo $LOGF      #>> $LOGF 2>&1
#mkdir -p $LOGP  #>> $LOGF 2>&1
#env | grep YAZI
#source $ACTIVATE
source $ACTI

$PYENV version
#$PIP list
cd $CAMP_TM/tm
ls .

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"         >> $LOGF
echo "###::$VER Hooks log 4 auto deploy tm.101.camp"     >> $LOGF
echo "###::run@" `date +"%Y/%m/%d %H:%M:%S"`                    >> $LOGF


inv -l



#echo "###::end@" `date +"%Y/%m/%d %H:%M:%S"` 
echo "###::end@" `date +"%Y/%m/%d %H:%M:%S"` >>                 $LOGF
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"         >> $LOGF
echo   >> $LOGF
#=========================================================== action DONE
exit  0
