import os, shlex
from pathlib import Path

_default_actions = {
    'inode/directory': 'ls',
    'text/plain': 'vim',
    'image/png': 'xdg-open'
}

if not __xonsh__.env.get('XONTRIB_ONEPATH_ACTIONS'):
    __xonsh__.env['XONTRIB_ONEPATH_ACTIONS'] = _default_actions

_act = __xonsh__.env.get('XONTRIB_ONEPATH_ACTIONS')


def _get_subproc_output(cmds, debug=False):
    cmds = [str(c) for c in cmds]
    if not debug:
        cmds += ['2>', '/dev/null']
    result = __xonsh__.subproc_captured_object(cmds)
    result.rtn  # workaround https://github.com/xonsh/xonsh/issues/3394
    return result.output


@events.on_transform_command
def onepath(cmd, **kw):
    args = shlex.split(cmd)
    if len(args) != 1:
        return cmd

    debug = __xonsh__.env.get('XONTRIB_ONEPATH_DEBUG', False)
    path = args[0]
    file_type = None
    s = 0
    while file_type in [None, 'inode/symlink'] and s < 10:
        path = Path(path).expanduser()
        if not path.exists() or ( path.is_file() and os.access(path, os.X_OK) ):
            return cmd

        file_type = _get_subproc_output(['file', '--mime-type', '--brief', path], debug).strip()
        if file_type == 'inode/symlink':
            path = _get_subproc_output(['readlink', '-f', path], debug).strip()
        else:
            break
        s += 1

    if s == 10:
        # symlink recursion
        return cmd

    path_filename = None if path.is_dir() else path.name
    path_suffix = path.suffix
    path_suffix_key = '*' + path.suffix
    file_type_suffix = file_type + path_suffix
    action = None
    for k in [path_filename, path_suffix_key, file_type_suffix, file_type]:
        if k in __xonsh__.env['XONTRIB_ONEPATH_ACTIONS']:
            action = __xonsh__.env['XONTRIB_ONEPATH_ACTIONS'][k]
            break

    if action:
        return f'{action} {path}\n'
    else:
        return cmd
