#!/bin/sh
#Pickup the commit details
while read oldrev newrev refname
do
        branch=`echo $refname | cut -d'/' -f3`
        old=`echo $oldrev | cut -c1-5`
        new=`echo $newrev | cut -c1-5`
done

        echo "You are pushing revision ID $new to branch $branch"
        echo "$branch currently points to commit $old"
        echo ""
        
DATE="2014-03-31"

#commits before $DATE, will not be examined
commitdate=`git show -s --format=%ci $new | awk '{print $1}'`

#the functions gets the commit date and the limit date we've set
function comparedate {

commitepoch=`date --date="$1" +%s`
dateepoch=`date --date="$2" +%s`
if  [ $commitepoch -gt $dateepoch ];then
                return 0
        else
                return 1
fi
}
flag=false

for rev in `git rev-list $old..$new`;do
mess=`git cat-file commit $rev |  sed '1,/^$/d'`
if  comparedate $commitdate $DATE ;then isexpired=1;else isexpired=0;fi
echo $mess | grep  -q ^'#US:[0-9]* \|#[Dd]efect:[0-9]* \|#[Ii]nternal: \|Merge branch'

if [ $? -ne 0 ] && [ $isexpired -eq 1 ];then

        echo "        You commit message:"
        echo "                         "
        echo "                $mess"
        echo "                         "
        echo "        For commit:"
        echo "                  $rev"
        echo "        does not match our commit"
        echo "  message standard !!!"
flag=true
fi

done


if [[ $flag == "true" ]];then
echo "                                          "
echo "
        ################################################

        Pay Attention!
        Your commit is rejected, you need to use the following format :
        
        Please use the following format:
                ^'#US:[0-9]* [ FREE TEXT MESSAGE ]'
        OR
                ^'#[Dd]efect:[0-9]* [ FREE TEXT MESSAGE ]'
        OR
                ^'#[Ii]nternal: [ FREE TEXT MESSAGE ]'
        For example:

        #US:8834 Add the monitor to the page
        #Defect:9274 Fix the header on the example page
        #Internal: Fix the bla bla on the yada yada

        Fix the commit and 
         try to push it again

        ################################################
                                                        "

        exit 0
fi
