pdxFile="pdportal-02-net-tac-toe.pdx"

cp ../../pdportal.lua ./src/pdportal.lua
pdc -q src "$pdxFile"

runChoice=$1

if [ "$runChoice" = "s" ]; then
	open "$pdxFile"
elif [ "$runChoice" = "d" ]; then
	node ../../../scripts/uploadPdxToPlaydate.js "$pdxFile"
fi
