#!/usr/bin/env python3

import getpass
import subprocess
import readline
import os
import time
import configparser


class PasswordMenu:

    def session(self):
        print('Decrypting DB')
        while (db := self._get_decrypted_db()) is None:
            pass
        while self._action_input_entry(db):
            pass

    # actions
    def _action_input_entry(self, db):
        try:
            entry = self._pick_entry(db)
            if not entry:
                return False
            entry_actions = [
                'hostname',
                'username',
                'password',
            ]
            while (entry_action := self._fzf(entry_actions[1:])):
                self._autotype(entry[entry_actions.index(entry_action)])
            return True
        except Exception as e:
            print(f'Failed to input entry: {e}')
            return False

    def _pick_entry(self, db):
        entry_prompts = [
            f'{hostname}\t{username}'
            for (hostname, username, password) in db
        ]
        try:
            choice = self._fzf(entry_prompts)
            return db[entry_prompts.index(choice)]
        except ValueError:
            return None

    # db
    def _get_decrypted_db(self):
        master_password = getpass.getpass()
        profile_dir = self._find_profile_dir()
        import firefox_login_decryptor
        try:
            return [
                *firefox_login_decryptor.FirefoxLoginDecryptor(
                    os.path.join(profile_dir, 'key4.db'),
                    os.path.join(profile_dir, 'logins.json'),
                    master_password
                ).decrypt()
            ]
        except Exception as e:
            return None

    def _find_profile_dir(self):
        firefox_dir = os.path.expanduser('~/.mozilla/firefox')
        config_parser = configparser.ConfigParser()
        config_parser.read(os.path.join(firefox_dir, 'installs.ini'))
        section = config_parser.sections()[0]
        profile = config_parser[section]['Default']
        return os.path.join(firefox_dir, profile)

    # input handling
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
    pm = PasswordMenu()
    pm.session()

if __name__ == '__main__':
    main()
