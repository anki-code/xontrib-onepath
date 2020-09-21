<p align="center">
When you click to a file or folder in graphical OS they will be opened in associated app. The xontrib-onepath brings the same logic for the <a href="https://github.com/xonsh/xonsh/">xonsh shell</a>. Type the filename or path without preceding command and an associated action will be executed. The actions are customizable.
</p>

<p align="center">  
If you like the idea of bar theme click ⭐ on the repo and stay tuned by watching releases.
</p>

## Install
While [development in progress](https://github.com/xonsh/xonsh/pull/3768) you can try this way:
```bash
bash
cd /tmp && git clone -b patch-2 https://github.com/anki-code/xonsh
pip install -U ./xonsh
pip install -U git+https://github.com/anki-code/xontrib-onepath
xonsh
xontrib load onepath
/home
```

In the future:
```
xpip install -U xontrib-onepath
echo 'xontrib load onepath' >> ~/.xonshrc
# Reload xonsh
```

## Example
```bash
$ /home  # ls for directories
alex

$ /etc/lsb-release  # head for text files
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04

$ /usr/bin/uname  # executable still works as executable
Linux
```

## Customize actions
Use `XONTRIB_ONEPATH_ACTIONS` environment variable to add new actions.

#### List files in zip archive via [als](https://www.nongnu.org/atool/)
```python
$XONTRIB_ONEPATH_ACTIONS['file'].append({
    'name':  'ls zip file',                      # any name
    'check': lambda p: str(p).endswith('.zip'),  # check that file ends to .zip
    'act':   lambda p: (['als', str(p)],),       # als from atool to show list of zipped files
})
```

#### Enable changing to a directory by entering the dirname (without the cd command)
You can enable this feature in Xonsh by setting [`$AUTO_CD = True`](https://xonsh.github.io/envvars.html#auto-cd) or you can use onepath actions for this:
```python
$XONTRIB_ONEPATH_ACTIONS['dir'] = [{
    'name':  'auto cd',
    'check': lambda p: True,
    'act':   lambda p: (['cd', str(p)],),
}]
```
