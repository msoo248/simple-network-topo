import sys
import pytest
import os
import subprocess

@pytest.mark.parametrize('ip', [
    '10.0.1.10',
    '10.0.1.20',
    '10.0.2.10',
    '10.0.2.20',
    '10.0.3.10',
    '10.0.3.20',
    '10.0.4.10',
    '10.0.4.20'
])

def test_ping(ip):
    output = os.system('ping -c 1 ' + ip)
    assert output == 0, f'Ping to {ip} failed'

def test_neighbor_exist():
    output = subprocess.run(['sudo', 'vtysh', '-c', 'show ip ospf neighbor'], capture_output = True, text = True)
    assert output.returncode == 0
    assert 'No neighbors found' not in output.stdout

@pytest.mark.parametrize('neighbor_ip', [
    '10.0.4.10',
    '10.0.3.10'
])

def test_correct_neighbor(neighbor_ip):
    output = subprocess.run(['sudo', 'vtysh', '-c', 'show ip ospf neighbor'], capture_output = True, text = True)
    found = False
    for line in output.stdout.split('\n'):
        if not line:
            continue
        ip_addr = line.split()[0]
        if ip_addr == neighbor_ip:
                found = True
                break
    assert found, f'Neighbor with address {neighbor_ip} does not exist'
    
@pytest.mark.parametrize('ospf_id', [
    '10.0.2.20'
])
def test_ospf(ospf_id):
    output = subprocess.run(['sudo', 'vtysh', '-c', 'show ip ospf'], capture_output = True, text = True)
    ospf_conf = output.stdout
    assert f"Router ID: {ospf_id}" in ospf_conf, f'OSPF with this ID does not exist'
