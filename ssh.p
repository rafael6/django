__author__ = 'rafael'

from net_system.models import NetworkDevice
import django
import paramiko
import socket


def ssh(ip, port, username, password, command):
    """
    Open and SSH channel with the given parameters, execute a given command on
    the remote system and returns the command output.
    :param ip: The ip address of the target device.
    :param port: The SSH port used for the connection.
    :param username: Username with access to the target device.
    :param password: Valid password.
    :param command: The command to be executed at the target device.
    :return: The output of the command
    """
    paramiko.util.log_to_file('paramiko.log')
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        client.connect(ip, port, username, password,
                       look_for_keys=False, allow_agent=False)
    except socket.error:
        return 'Node %s is not answering; check hostname or IP.' % ip
    except paramiko.AuthenticationException:
        return 'Authentication failed; check username and password.'
    except KeyboardInterrupt:
        print '  Goodbye'
        exit()
    else:
        stdin, stdout, stderr = client.exec_command(command)
        return stdout.read()
    finally:
        client.close()


def get_serial_number(device, command):
    """
    Gets the IP, port, username, and password attributes from a given device.
    Calls SHH function with such attributes and parses the command output for a
    serial number.
    :param device:
    :param command:
    """
    target = NetworkDevice.objects.get(device_name=device)
    output = ssh(target.ip_address, target.ssh_port, target.credentials.username,
                 target.credentials.password, command)
    serial_no = output.partition("SN: ")[2]
    target.serial_number = serial_no.strip()
    print 'Stored serial number {} on serial_number field for device {}.'\
        .format(target.serial_number, device)


def main():
    """ Sets django and control script sequence"""
    django.setup()
    get_serial_number('pynet-rtr2', 'show inventory')


if __name__ == "__main__":
    main()
