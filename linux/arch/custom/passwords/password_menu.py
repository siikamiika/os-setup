#!/usr/bin/env python3

import getpass
import subprocess
import readline
import os
import time


class PasswordMenu:
    _ACTION_INPUT_ENTRY = 1
    _ACTION_ADD_ENTRY = 2
    _ACTION_DELETE_ENTRY = 3

    def __init__(self, db_path):
        self._db_path = db_path

    def session(self):
        print('Decrypting DB')
        while (db := self._get_decrypted_db()) is None:
            pass
        while self._session_action_prompt(db):
            pass

    # prompt
    def _session_action_prompt(self, db):
        prompt_actions = self._get_prompt_actions(db)
        prompt = []
        for action, (desc, _) in prompt_actions.items():
            prompt.append(f'{action}. {desc}')
        try:
            choice = self._fzf(prompt)
            action = int(choice.split('.', 1)[0])
        except ValueError:
            return False
        prompt_actions[action][1]()
        return True

    def _get_prompt_actions(self, db):
        return {
            self._ACTION_INPUT_ENTRY: (
                'Input entry',
                lambda: self._action_input_entry(db),
            ),
            self._ACTION_ADD_ENTRY: (
                'Add entry',
                lambda: self._action_add_entry(db),
            ),
            self._ACTION_DELETE_ENTRY: (
                'Delete entry',
                lambda: self._action_delete_entry(db),
            ),
        }

    # actions
    def _action_input_entry(self, db):
        try:
            entry = self._pick_entry(db)
            if not entry:
                return False
            entry_actions = [
                'username',
                'password',
                'url',
            ]
            while (entry_action := self._fzf(entry_actions)):
                self._autotype(getattr(entry, entry_action))
            return True
        except Exception as e:
            print(f'Failed to input entry: {e}')
            return False

    def _action_add_entry(self, db):
        try:
            db.add_entry(
                destination_group=db.root_group,
                title=self._input('Title: ', ''),
                username=self._input('Username: ', os.environ['USER']),
                url=self._input('URL: ', 'https://'),
                password=getpass.getpass(),
            )
            db.save()
            return True
        except Exception as e:
            print(f'Failed to add entry: {e}')

    def _action_delete_entry(self, db):
        entry = self._pick_entry(db)
        if entry:
            db.delete_entry(entry)
            db.save()

    def _pick_entry(self, db):
        entries = db.entries
        padding = '\t' * 30
        entry_prompts = [
            f'{e.url} {e.username} {e.title}{padding}{e.uuid}'
            for e in entries
        ]
        try:
            choice = self._fzf(entry_prompts)
            return entries[entry_prompts.index(choice)]
        except ValueError:
            return None
        # TODO
        # db.find_entries(title='.*', url='.*', regex=True)

    # db
    def _get_decrypted_db(self):
        password = getpass.getpass()
        import pykeepass
        try:
            return pykeepass.PyKeePass(self._db_path, password=password)
        except pykeepass.exceptions.CredentialsError:
            print('Invalid password')
            return None

    # input handling
    def _input(self, prompt, text):
        def hook():
            readline.insert_text(text)
            readline.redisplay()
        readline.set_pre_input_hook(hook)
        result = input(prompt)
        readline.set_pre_input_hook()
        return result

    def _fzf(self, lines):
        fzf = subprocess.Popen(
            ['fzf', '--layout=reverse'],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE
        )
        if not fzf.stdin:
            raise Exception('Could not open fzf stdin')
        if not fzf.stdout:
            raise Exception('Could not open fzf stdout')
        fzf_input = ''.join([l + '\n' for l in lines]).encode('utf-8')
        fzf.stdin.write(fzf_input)
        fzf.stdin.close()
        return fzf.stdout.read().rstrip(b'\r\n').decode('utf-8')

    def _autotype(self, text):
        wtype = subprocess.Popen(['wtype', '-'], stdin=subprocess.PIPE)
        if not wtype.stdin:
            raise Exception('Could not open wtype stdin')
        time.sleep(2)
        wtype.stdin.write(text.encode('utf-8'))
        wtype.stdin.close()


def main():
    db_path = os.path.expanduser('~/.config/password_menu/db.kdbx')
    pm = PasswordMenu(db_path)
    pm.session()

if __name__ == '__main__':
    main()
