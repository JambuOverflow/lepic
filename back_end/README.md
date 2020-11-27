# Django Back End

## Use virtualenv

### Create virtual environment

* ```virtualenv env```

### Activate virtual environment

* Linux: ```source env/bin/activate```
* Windows: ```/env/Scripts/activate```

## Install requirements in virtualenv

* ```pip install -r requirements.txt```

## Add SECRET KEY

* Put [```lepic_secrets.py```](https://github.com/JambuOverflow/secrets/blob/master/secrets.py) in ```./back_end/lepic_secrets.py```

### When you want to leave virtualenv

* ```deactivate```

## API DOCUMENTATION

* Run ```python3 manage.py runserver```

* create_user: ```<localhost>/api/create_user```

* Update user: ```<localhost>/api/update_user/<user_id>```
