pdxFile="pdportal-04-fetch.pdx"

cp ../../pdportal.lua ./src/pdportal.lua
pdc src "$pdxFile"

runChoice=$1

if [ "$runChoice" = "s" ]; then
	open "$pdxFile"
elif [ "$runChoice" = "d" ]; then
	node ../../../scripts/uploadPdxToPlaydate.js "$pdxFile"
fi
