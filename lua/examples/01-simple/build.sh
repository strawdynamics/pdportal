pdxFile="pdportal-01-simple.pdx"

cp ../../pdportal.lua ./src/pdportal.lua
pdc src "$pdxFile"

read -t 5 -p "Run on sim or device? s, d, or blank/wait to skip: " runChoice

if [ "$runChoice" = "s" ]; then
	open "$pdxFile"
elif [ "$runChoice" = "d" ]; then
	node ../../../scripts/uploadPdxToPlaydate.js "$pdxFile"
fi
