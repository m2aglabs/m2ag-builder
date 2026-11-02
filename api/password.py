from pathlib import Path

from passlib.apache import HtpasswdFile


class Password:
    USER_FILE = Path(__file__).resolve().parent.parent / 'config' / '.htpasswd'

    @staticmethod
    def _userdb():
        return HtpasswdFile(
            str(Password.USER_FILE),
            default_scheme='apr_md5_crypt',
            autosave=True
        )

    @staticmethod
    def change_password(data):
        userdb = Password._userdb()
        if userdb.get_hash(data['user']) is None:
            return False
        userdb.set_password(data['user'], data['password'])
        return userdb.users()

    @staticmethod
    def add_user(data):
        userdb = Password._userdb()
        if userdb.get_hash(data['user']) is not None:
            return False
        userdb.set_password(data['user'], data['password'])
        return userdb.users()

    @staticmethod
    def delete_user(data):
        userdb = Password._userdb()
        if not userdb.delete(data['user']):
            return False
        return userdb.users()

    @staticmethod
    def get_users():
        return Password._userdb().users()
