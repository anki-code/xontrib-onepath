<p align="center">
When you click to a file or folder in graphical OS they will be opened in associated app. The xontrib-onepath brings the same logic for the <a href="https://github.com/xonsh/xonsh/">xonsh shell</a>. Type the filename or path without preceding command and an associated action will be executed. The actions are customizable.
</p>

<p align="center">  
If you like the idea of bar theme click ⭐ on the repo and stay tuned by watching releases.
</p>

## Install
```bash
xpip install -U xontrib-onepath
echo 'xontrib load onepath' >> ~/.xonshrc
# Reload xonsh
```

## Default actions
If file has execution permission it will be executed. If typed command is a registered name (i.e. `git`) 
and `which` command returns the path (i.e. `/usr/bin/git`) it will be executed. In other case the typed
path will be used to make action. Default actions: 

| Type  | Action  |
|---|---|
| `DIR`  | `ls`  | 
| `text/` | `vim`|
| `image/` | `xdg-open` |

Help to add more types and best default actions. PRs are welcome!

## Examples
```bash
$ /                      # ls /
$ ~/.xonshrc             # vim ~/.xonshrc
$ ~/Downloads/logo.png   # xdg-open ~/Downloads/logo.png
$ git                    # git
$ ./git                  # ls ./git
```

## Type format

| Priority | Format  | Example  |
|----------|---------|----------|
| 1 | Full path to file.                | `/etc/passwd`     |
| 2 | File name.                        | `file.txt`        | 
| 3 | File extension.                   | `*.txt`           |
| 4 | MIME type/subtype and extension.  | `text/plain.txt`  |
| 5 | MIME type/subtype.                | `text/plain`      |
| 6 | MIME type.                        | `text/`           |
| 7 | Any file.                         | `FILE` (constant) |
| 8 | Any directory.                    | `DIR` (constant)  |
| 9 | Any file or directory.            | `*` (constant)    |

To get MIME type for the file run `file --mime-type --brief <file>`.

## Customize actions
Use `XONTRIB_ONEPATH_ACTIONS` environment variable to add new actions:

```python
$XONTRIB_ONEPATH_ACTIONS['.xonshrc'] = 'vim'         # vim for `.xonshrc` file
$XONTRIB_ONEPATH_ACTIONS['*.log'] = 'tail'           # tail for text type *.log files
$XONTRIB_ONEPATH_ACTIONS['text/plain.txt'] = 'less'  # less for plain text *.txt files 
$XONTRIB_ONEPATH_ACTIONS['DIR'] = 'cd'               # the same as xonsh $AUTO_CD=True
$XONTRIB_ONEPATH_ACTIONS['application/zip'] = 'als'  # list files in zip file using atool
```

## Complex actions

If you need more complex actions use [callable xonsh aliases](https://xon.sh/tutorial.html#callable-aliases):
```python
import pandas as pd
def _view_csv_with_pandas(args):
    print(pd.read_csv(args[0]))

aliases['view_csv_with_pandas'] = _view_csv_with_pandas
del _view_csv_with_pandas

$XONTRIB_ONEPATH_ACTIONS['application/csv'] = 'view_csv_with_pandas'
```

## Known issues
### NTFS in Linux: all files have execute permission
If you mount NTFS partition with default permissions then all files will have execute permission 
and `onepath` will execute them instead of action. The right way 
is to [change default `/etc/fstab` settings](https://askubuntu.com/questions/113733/how-do-i-correctly-mount-a-ntfs-partition-in-etc-fstab).
Example:
```bash
sudo umount /d
sudo mount -o uid=1000,gid=1000,dmask=027,fmask=137 /d 
ls -la /d
```