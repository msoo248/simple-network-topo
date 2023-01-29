import pytest
import os
import subprocess

@pytest.mark.parametrize('ip', [
    '172.31.2.74',
    '172.31.69.200',
    '10.0.0.1',
    '10.0.0.2'
])

def test_ping(ip):
    output = os.system('ping -c 1 ' + ip)
    assert output == 0, f'Ping to {ip} failed'

def test_neighbor_exist():
    output = subprocess.run(['sudo', 'vtysh', '-c', 'show ip ospf neighbor'], capture_output = True, text = True)
    assert output.returncode == 0
    assert 'No neighbors found' not in output.stdout

def test_correct_neighbor():
    output = subprocess.run(['sudo', 'vtysh', '-c', 'show ip ospf neighbor'], capture_output = True, text = True)
    searched_ip = '10.0.0.2'
    found = False
    for line in output.stdout.split('\n'):
        if not line:
            continue
        ip_addr = line.split()[0]
        if ip_addr == searched_ip:
                found = True
                break
    assert found, f'Neighbor with address {searched_ip} does not exist'
def test_ospf():
    output = subprocess.run(['sudo', 'vtysh', '-c', 'show ip ospf neighbor'], capture_output = True, test = True)
    ospf_conf = output.stdout
    assert "Router ID: 10.0.0.1" in ospf_conf, f'OSPF with this ID does not exist'
