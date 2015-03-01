# django
w7e1:
Initialize your Django database. Add the six NetworkDevice objects and two Credentials objects into your database.  
After this initialization, you should be able to do the following (from the ~/DJANGOX/djproject directory):

$ python manage.py shell

>>> from net_system.models import NetworkDevice, Credentials
>>> net_devices = NetworkDevice.objects.all()
>>> net_devices
[<NetworkDevice: pynet-rtr1>, <NetworkDevice: pynet-rtr2>, <NetworkDevice: pynet-sw1>, 
<NetworkDevice: pynet-sw2>, <NetworkDevice: pynet-sw3>, <NetworkDevice: pynet-sw4>]

>>> creds = Credentials.objects.all()
>>> creds
[<Credentials: pyclass>, <Credentials: admin1>]

    b. Update the NetworkDevice objects such that each network device links to the correct credentials.

w7e2:
Add an SnmpCredentials model to the models.py file. This model should support both SNMPv3 and SNMPv1/v2c. 
Add a foreign key reference in the NetworkDevice model pointing to this SnmpCredentials model.

    a. Update the database to reflect the new models.py file using Django's 'makemigrations' and 'migrate' commands.

    b. Create an SnmpCredentials object using the SNMPv3 credentials of username = 'pysnmp' and auth_key/encrypt_key = 'galileo1'.

    c. Update the two Cisco NetworkDevice objects such that they reference this SnmpCredentials object.
