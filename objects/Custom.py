import random
import string
from datetime import datetime, timedelta


__version__ = '1.0.0'
class Custom:
    ROBOT_LIBRARY_VERSION = __version__
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    def get_random_email(self, domain="demo.com"):
        username = "".join(random.choice(string.ascii_letters) for _ in range(8))
        email = f"{username}@{domain}"
        return email

    def get_current_date(self, date_format="%Y-%m-%d"):
        current_date = datetime.now().strftime(date_format)
        return current_date
    
    def get_future_date(self, date_format="%Y-%m-%d"):
        current_date = datetime.now()
        delta = timedelta(days=4)
        future_date = (current_date + delta).strftime(date_format)
        return future_date

    def get_random_name(self, length=8):
        name = "".join(random.choice(string.ascii_letters) for _ in range(length))
        return name