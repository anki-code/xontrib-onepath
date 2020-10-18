import os, shlex
from magic import from_file as mime
from pathlib import Path
from shutil import which

_env_actions = __xonsh__.env.get('XONTRIB_ONEPATH_ACTIONS')
if not _env_actions or type(_env_actions) != dict:
    _actions = {
        '<DIR>': 'cd',
        '<XFILE>': '<RUN>',
        'text/': 'vim'
    }

    if __xonsh__.env.get('DISPLAY', False):
        _actions['image/'] = 'xdg-open'

    __xonsh__.env['XONTRIB_ONEPATH_ACTIONS'] = _actions


def _get_subproc_output(cmds, debug=False):
    cmds = [str(c) for c in cmds]
    if not debug:
        cmds += ['2>', '/dev/null']
    result = __xonsh__.subproc_captured_object(cmds)
    result.rtn  # workaround https://github.com/xonsh/xonsh/issues/3394
    return result.output


@events.on_transform_command
def onepath(cmd, **kw):
    try:
        args = shlex.split(cmd)
    except:
        return cmd
    if len(args) != 1 or which(args[0]) or args[0] in aliases:
        return cmd

    debug = __xonsh__.env.get('XONTRIB_ONEPATH_DEBUG', False)
    path = Path(args[0]).expanduser().resolve()
    if not path.exists():
        return cmd

    if __xonsh__.env.get('XONTRIB_ONEPATH_SUBPROC_FILE', False):
        file_type = _get_subproc_output(['file', '--mime-type', '--brief', path], debug).strip()
    else:
        try:
            file_type = mime(str(path), mime=True)
        except IsADirectoryError:
            file_type = 'inode/directory'

    file_type = '<DIR>' if file_type == 'inode/directory' else file_type
    full_path = str(path)
    path_filename = None if path.is_dir() else path.name
    path_suffix_key = '*' + path.suffix
    file_or_dir = '<FILE>' if path.is_file() else '<DIR>'
    xfile = '<XFILE>' if path.is_file() and os.access(path, os.X_OK) else '<NX>'
    file_type_group = file_type.split('/')[0] + '/' if '/' in file_type else None
    path_suffix = path.suffix
    file_type_suffix = file_type + path_suffix
    action = None
    for k in __xonsh__.env['XONTRIB_ONEPATH_ACTIONS']:
        if k in [full_path, path_filename, path_suffix_key, file_type_suffix, file_type, file_type_group, file_or_dir, xfile, '*']:
            action = __xonsh__.env['XONTRIB_ONEPATH_ACTIONS'][k]
            break

    if action:
        if action == '<RUN>':
            return f'{shlex.quote(str(path))}\n'
        else:
            return f'{action} {shlex.quote(str(path))}\n'
    else:
        return cmd
