java -jar tools/jmerge/JMerge.jar -merge $1 $2 $3 $2
if [ "$?" -gt 0 ]
then
    echo "Unable to automatically resolve map conflicts, please merge manually."
    exit 1
fi
java -jar tools/jmerge/JMerge.jar -clean $3 $2 $2

exit 0
