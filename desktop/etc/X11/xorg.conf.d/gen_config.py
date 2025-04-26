import os
import re
import logging


def list_dir(path):
    files = os.listdir(path)
    return [os.path.join(path, f) for f in files]


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger('conf_gen')


# find all pci devices using amdgpu
devices = [
    os.path.realpath(p)
    for p in list_dir('/sys/bus/pci/drivers/amdgpu/')
]
devices = [
    p for p in devices if p.startswith('/sys/devices/pci')
]

# pick first one and convert bus ID to xorg format
bus_ids = sorted([
    os.path.split(p)[1] for p in devices
])
logger.info('Found Bus IDS: %s', bus_ids)
bus_id = 'PCI:' + ':'.join(
    str(int(i, 16))
    for i in re.split(r'(?i)[^\da-f]', bus_ids[0])[1:]
)

logger.info('Writing config...')
config = f'''
Section "Device"
    Identifier "AMD"
    Driver "amdgpu"
    Option "SWCursor" "False"
    Option "TearFree" "True"
    Option "VariableRefresh" "True"
    Option "AsyncFlipSecondaries" "true"
    BusID "{bus_id}"
EndSection
'''

with open('/tmp/20-amdgpu.conf', 'w') as f:
    f.write(config)
