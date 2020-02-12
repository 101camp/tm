#! /bin/bash
export CAMPSITES_ROOT="/opt/www/101camp"
#echo $DU19SRC_ROOT
#source /home/du19/.bashrc
#=========================================================== var defines
VER="cron4trig2tm.sh v.200211.1942"
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
#NOW=`date +"%y%m%d_%H%M%S"`
TODAY=`date +"%y%m%d"`

export CAMP_TM=/opt/www/101camp/TM

AIMP=$CAMP_TM/dlog_tm101camp
LOGP=$AIMP/$YEAR/$MONTH
LOGF=$LOGP/$TODAY-tm.log
#=========================================================== action defines
#echo $LOGP
#echo $LOGF
mkdir -p $LOGP

source $ACTI

#$PYENV version
#$PIP list
cd $CAMP_TM/tm
#ls .

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"         >> $LOGF
echo "###::$VER Hooks log 4 auto deploy tm.101.camp"     >> $LOGF
echo "###::run@" `date +"%Y/%m/%d %H:%M:%S"`                    >> $LOGF


#inv -l              >> $LOGF 2>&1
inv pub tm          >> $LOGF 2>&1

cd $AIMP
NOW=`date +"%y%m%d %H"%M"%S"`
git upd "$VER try deploy tm.101.camp /at $NOW"

#echo "###::end@" `date +"%Y/%m/%d %H:%M:%S"` 
echo "###::end@" `date +"%Y/%m/%d %H:%M:%S"` >>                 $LOGF
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"         >> $LOGF
echo   >> $LOGF
#=========================================================== action DONE
exit  0
