pdxFile="pdportal-05-ping.pdx"

cp ../../pdportal.lua ./src/pdportal.lua
pdc src "$pdxFile"

runChoice=$1

if [ "$runChoice" = "s" ]; then
	open "$pdxFile"
elif [ "$runChoice" = "d" ]; then
	node ../../../scripts/uploadPdxToPlaydate.js "$pdxFile"
fi
