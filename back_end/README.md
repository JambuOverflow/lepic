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

* Put [```secrets.py```](https://github.com/JambuOverflow/secrets/blob/master/secrets.py) in ```./back_end/back_end/secrets.py```

### When you want to leave virtualenv

* ```deactivate```