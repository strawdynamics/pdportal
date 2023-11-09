WIP

```
globalFunc('somestring')
```

The bytecode is nearly identical for different strings, but the `('` changes (obviously not what's actually happening) based on the string length:

* '' -> 0481
* 'h' -> 0482
* 'he' -> 0483
* 'hel' -> 0484
* 40 chars -> 04A9 (39 dec more than 82 hex, as exected)
* 41 chars -> 14AA (LUAI_MAXSHORTLEN <https://www.lua.org/source/5.4/llimits.h.html>)
* 41 + 85 = 126 chars -> 14FF, as expected
* 127 chars -> 140180, as expected
* 1000 chars('hello') -> 1407E9

* 100 chars ('hello') -> 14E5
* different 100 chars ('abcde') -> Still 14E5

OKAY this finally all makes sense after reading the comment on <https://www.lua.org/source/5.4/ldump.c.html#dumpSize>. `buff[DIBS - 1] |= 0x80;  /*mark last byte*/`. I had it backwards before, it's only the _last_ byte flagged `0x80`!

As a note to future people (probably me): Neither unluac or <https://luadec.metaworm.site/> work with `pdc`-compiled bytecode. <https://github.com/scratchminer/unluac> does though!

```
pdc gf1.lua
node pdz.js gf1.pdz .
```
