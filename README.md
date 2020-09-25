<p align="center">
When you click to a file or folder in graphical OS they will be opened in associated app. The xontrib-onepath brings the same logic for the <a href="https://github.com/xonsh/xonsh/">xonsh shell</a>. Type the filename or path without preceding command and an associated action will be executed. The actions are customizable.
</p>

<p align="center">  
If you like the idea of bar theme click ⭐ on the repo and stay tuned by watching releases.
</p>

## Install
```
xpip install -U xontrib-onepath
echo 'xontrib load onepath' >> ~/.xonshrc
# Reload xonsh
```

## Default actions
| File type  | Action  |
|---|---|
| inode/directory  | `ls`  | 
| text/plain | `vim`|
| image/png | `xdg-open` |

Help to add more types and best default actions. PRs are welcome!

## Customize actions
Use `XONTRIB_ONEPATH_ACTIONS` environment variable to add new actions:

```python
$XONTRIB_ONEPATH_ACTIONS['.xonshrc'] = 'vim'         # vim for `.xonshrc` file
$XONTRIB_ONEPATH_ACTIONS['*.log'] = 'tail'           # tail for text type *.log files
$XONTRIB_ONEPATH_ACTIONS['text/plain.txt'] = 'less'  # less for plain text *.txt files 
$XONTRIB_ONEPATH_ACTIONS['inode/directory'] = 'cd'   # the same as xonsh $AUTO_CD=True
$XONTRIB_ONEPATH_ACTIONS['application/zip'] = 'als'  # list files in zip file using atool
```
To get file type for new file run `file --mime-type --brief <file>`.

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
