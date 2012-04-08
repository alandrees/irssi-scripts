#!/bin/sh

XMLRPC2SCGI='/home/deepie/scripts/xmlrpc2scgi.2.py'
ADDRESS='scgi://192.168.1.134:5000'

if [ "$1" = "upload_rate" ]
then
    RATE=`$XMLRPC2SCGI $ADDRESS get_up_rate`

    if [ $RATE -ge 1000000 ]
    then
        RATE=$(echo "scale=2$RATE / 1000000" | bc -l)
        echo "$RATE"MiB
        return
    fi

    if [ $RATE -ge 1000 ]
    then
        RATE=$(echo "scale=2;$RATE / 1000" | bc -l)
        echo "$RATE"KiB
        return
    fi

    if [ $RATE -lt 1000 ]
    then
        echo "$RATE"B
        return
    fi

fi

if [ "$1" = "download_rate" ]
then
    RATE=`$XMLRPC2SCGI $ADDRESS get_down_rate`
    if [ $RATE -ge 1000000 ]
    then
        RATE=$(echo "scale=2;$RATE / 1000000" | bc -l)
        echo "$RATE"MiB
        return
    fi

    if [ $RATE -ge 1000 ]
    then
        RATE=$(echo "scale=2;$RATE / 1000" | bc -l)
        echo "$RATE"KiB
        return
    fi

    if [ $RATE -lt 1000 ]
    then
        echo "$RATE"B
        return
    fi
fi