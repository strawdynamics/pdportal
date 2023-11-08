WIP

```
globalFunc('somestring')
```

The bytecode is nearly identical for different strings, but the `('` changes (obviously not what's actually happening) based on the string length:

* 'h' -> 0482
* 'he' -> 0483
* 'hel' -> 0484
* 100 chars ('hello') -> 14E5
* different 100 chars ('abcde') -> Still 14E5
* 1000 chars('hello') -> 1407E9

As a note to future people (probably me): Neither unluac or <https://luadec.metaworm.site/> work with `pdc`-compiled bytecode.

```
pdc gf1.lua
node pdz.js gf1.pdz .
```
