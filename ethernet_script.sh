#!/bin/bash


# check if there is no argument
if [ $# -eq 0 ]
then
   echo "usage:"
   echo "./script.sh [ speed 10/100/1000 ] [ duplex half/full ]"
   exit
fi

#setup speedVal and duplexVal
if [ $1 == "speed" ]
then
   speedVal=$2
   duplexVal=$4
elif [ $1 == "duplex" ]
then
   duplexVal=$2
   speedVal=$4
else
   echo "Mau lu apa jing"
fi

echo "speed $speedVal"
echo "duplex $duplexVal"


#check if values is valid
if [ $speedVal ] && [ $speedVal -gt 1000 ]
then
   echo "Bad parameter value"
   exit
fi
#-----------------
if [ $speedVal ] && [ $speedVal -ne 10 ] && [ $speedVal -ne 100 ]  && [ $speedVal -ne 1000 ]
then
   echo "Bad parameter value"
fi
#-----------------
if [ $duplexVal ] && [ $duplexVal != "half" ] && [  $duplexVal != "full" ]
then
   echo "Bad parameter value"
   exit
fi

# get what group the user belong to
isUmum="$(grep umum /etc/group | grep $USER)"
isMember="$(grep member /etc/group | grep $USER)"
type="None"
if [ $isUmum ] && [ $isUmum != "" ]
then
   type="umum"
fi
if [ $isMember ] && [ $isMember != "" ]
then
   type="member"
fi

echo $type


if [ $type == "umum" ]
then
        if [ $speedVal ] && [ $speedVal -ne 10 ]
        then
                echo "Umum can only have 10Mbps"
        elif [ $duplexVal ] &&  [ $duplexVal != "half" ]
        then
                echo "Umum can only have half duplex"
        elif [ ! $speedVal ]
        then
                echo "RUN ethtool duplex $duplexVal"
                echo "sysprog2019" | sudo -S ethtool -s enp0s3 duplex $duplexVal
        elif [ ! $duplexVal ]
        then
                echo "RUN ethtool speed $speedVal"
                echo "sysprog2019" | sudo -S ethtool -s enp0s3 speed $speedVal
        else
                echo "ethtool speed $speedVal duplex $duplexVal"
                echo "sysprog2019" | sudo -S ethtool -s enp0s3 speed $speedVal duplex $duplexVal
        fi
elif [ $type == "member" ]
then
        if [ $speedVal ] && [ $speedVal -gt 100 ]
        then
                echo "member can only have 100Mbps"
        elif [ ! $speedVal ]
        then
                echo "RUN ethtool duplex $duplexVal"
                echo "sysprog2019" | sudo -S ethtool -s enp0s3 duplex $duplexVal
        elif [ ! $duplexVal ]
        then
                echo "RUN ethtool speed $speedVal"
                echo "sysprog2019" | sudo -S ethtool -s enp0s3 speed $speedVal
        else
                echo "RUN ethtool speed $speedVal duplex $duplexVal"
                echo "sysprog2019" | sudo -S ethtool -s enp0s3 speed $speedVal duplex $duplexVal
        fi
fi