from ranger.api.commands import Command

class fzf_select(Command):
    """
    :fzf_select

    Find a file using fzf.

    With a prefix argument select only directories.

    See: https://github.com/junegunn/fzf
    """
    def execute(self):
        import subprocess
        import os.path
        if self.quantifier:
            # match only directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        else:
            # match files and directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)
                self.fm.move(right=1)

def _execute_fzf_grep(command, open_line=True):
    import subprocess
    import os.path

    grep = subprocess.Popen([
        'grep',
        *[f'--exclude-dir={d}' for d in ['.git', '.hg']],
        '--line-buffered',
        '--color=never',
        '-snriI',
        ' '.join(command.args[1:])
    ], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)

    fzf = command.fm.execute_command(['fzf'], stdin=grep.stdout, stdout=subprocess.PIPE)
    grep.wait()
    stdout, stderr = fzf.communicate()

    if fzf.returncode == 0:
        grep_line = stdout.decode('utf-8').split(':', maxsplit=2)
        grep_file = os.path.abspath(grep_line[0])
        line_number = int(grep_line[1])
        if os.path.isfile(grep_file):
            command.fm.select_file(grep_file)
            if open_line:
                command.fm.execute_command(['nvim', f'+{line_number}', grep_file])
            else:
                command.fm.move(right=1)

class fzf_grep(Command):
    """Grep text recursively from the current directory and its subdirectories.
    Pipe output to fzf and open the selected line in nvim."""
    def execute(self):
        _execute_fzf_grep(self)

class fzf_grep_select(Command):
    """Used with vim"""
    def execute(self):
        _execute_fzf_grep(self, open_line=False)
