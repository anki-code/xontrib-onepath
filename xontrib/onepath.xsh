import os

_act_default = {
    'file':[
        {
            'name': 'executable',
            'check': lambda p: os.access(p, os.X_OK),
            'act': lambda p: ([str(p)],)
        },
        {
            'name': 'text',
            'check': lambda p: 'text' in $(file @(p)),
            'act': lambda p: (['head', str(p)],)
        }
    ],
    'dir':[
        {
            'name': 'default',
            'check': lambda p: True,
            'act': lambda p: (['ls', str(p)],)
        }
    ]
}

if not __xonsh__.env.get('XONTRIB_ONEPATH_ACTIONS'):
    $XONTRIB_ONEPATH_ACTIONS = _act_default

_act = __xonsh__.env.get('XONTRIB_ONEPATH_ACTIONS')


@events.on_run_subproc
def _onepath(cmds, **kw):
    if len(cmds) == 1 and len(cmds[0]) == 1:
        paths = cmds[0][0]
        path = fp'{paths}'
        if not path.exists():
            return cmds
        
        type = None 
        if path.is_dir():
            type = 'dir'
        elif path.is_file():
            type = 'file'
        
        if type:
            for a in _act[type]:
                if a['check'](path):
                    return a['act'](path)
                    
    return cmds
