pdxFile="pdportal-02-net-tac-toe.pdx"

cp ../../pdportal.lua ./src/pdportal.lua
pdc -q src "$pdxFile"

read -p "Run on sim or device? s, d, or blank/wait to skip: " runChoice

if [ "$runChoice" = "s" ]; then
	open "$pdxFile"
elif [ "$runChoice" = "d" ]; then
	node ../../../scripts/uploadPdxToPlaydate.js "$pdxFile"
fi
