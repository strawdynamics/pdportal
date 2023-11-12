pdxFile="pdportal-01-simple.pdx"

cp ../../pdportal.lua ./src/pdportal.lua
pdc src "$pdxFile"

runChoice=$1

if [ "$runChoice" = "s" ]; then
	open "$pdxFile"
elif [ "$runChoice" = "d" ]; then
	node ../../../scripts/uploadPdxToPlaydate.js "$pdxFile"
fi
