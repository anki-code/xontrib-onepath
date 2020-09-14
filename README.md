<p align="center">  
Use path without any leading commands (like ls, cat, etc) in <a href="https://xon.sh">xonsh shell</a>.
</p>

<p align="center">  
If you like the idea of bar theme click ⭐ on the repo and stay tuned.
</p>

## Install
```
xpip install -U xontrib-onepath
echo 'xontrib load onepath' >> ~/.xonshrc
# Reload xonsh
```

## Example
```bash
$ /home  # ls for directories
foo bar

$ ./onepath.xsh  # head for text files
import os
...

$ /bin/bash  # executable still works as executable
foo@host:~$
```

## Add your file types
Use `XONTRIB_ONEPATH_ACTIONS` environment variable to add new actions:
```python
$XONTRIB_ONEPATH_ACTIONS['file'].append({
    'name':  'ls zip file',                      # any name
    'check': lambda p: str(p).endswith('.zip'),  # check that file ends to .zip
    'act':   lambda p: (['als', str(p)],),       # als from atool to show list of zipped files
})
```
