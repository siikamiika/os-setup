#!/usr/bin/env python3

import getpass
import pykeepass


class PasswordMenu:
    _ACTION_SHOW_ENTRY = 1
    _ACTION_ADD_ENTRY = 2
    _ACTION_DELETE_ENTRY = 3

    def __init__(self, db_path):
        self._db_path = db_path

    def session(self):
        print('Decrypting DB')
        while True:
            try:
                db = self._get_decrypted_db()
                break
            except pykeepass.exceptions.CredentialsError:
                print('Invalid password')
        while self._session_action_prompt(db):
            pass

    # prompt
    def _session_action_prompt(self, db):
        print('What would you like to do?')
        prompt_actions = self._get_prompt_actions(db)
        for action, (desc, _) in prompt_actions.items():
            print(f'{action}. {desc}')
        try:
            action = int(input().strip())
        except ValueError:
            return False
        prompt_actions[action][1]()
        return True

    def _get_prompt_actions(self, db):
        return {
            self._ACTION_SHOW_ENTRY: (
                'Show entry',
                lambda: self._action_show_entry(db),
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
    def _action_show_entry(self, db):
        try:
            entries = self._find_entries(db)
            print(entries)
            return True
        except Exception as e:
            print(f'Failed to show entries: {e}')
            return False

    def _action_add_entry(self, db):
        try:
            db.add_entry(
                destination_group=db.root_group,
                title=input('Title: '),
                username=input('Username: '),
                url=input('URL: '),
                password=getpass.getpass(),
            )
            db.save()
            return True
        except Exception as e:
            print(f'Failed to add entry: {e}')

    def _action_delete_entry(self, db):
        raise Exception('TODO unimplemented')

    def _find_entries(self, db):
        return db.find_entries(
            title=input('Title pattern: '),
            url=input('URL pattern: '),
            regex=True,
        )

    # db
    def _get_decrypted_db(self):
        password = getpass.getpass()
        return pykeepass.PyKeePass(self._db_path, password=password)


def main():
    db_path = './db.kdbx'
    pm = PasswordMenu(db_path)
    pm.session()

if __name__ == '__main__':
    main()
