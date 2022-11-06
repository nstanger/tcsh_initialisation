# iTerm Shell integration

Typical prompts:

1. `klow:~$␣`
2. `nzougorg@nzoug.org␣[~]#␣`
3. `[stani07p@rtis-infos-db-01␣~]$␣`


## Report user & host 

To match 1 above:

```text
([-.\w\d]+)[: ]
```

To match 2 & 3 above:

```text
([:punct:\w\d]+)@([-.\w\d]+)[: ]
```

## Report directory

To match all of 1–3 above:

```text
[: ]\[?([^$#%\]]+)
```

## Prompt detected

To match all of 1–3 above:

```text
^.+[$#] ?$
```
