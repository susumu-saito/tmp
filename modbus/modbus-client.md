# Modbus Client
This is a simple Modbus TCP client that can read and write to Modbus TCP slaves.

## Docker Hub
[oitc/modbus クライアント](https://hub.docker.com/r/oitc/modbus-client)

## Usage

```bash
docker pull oitc/modbus-client

```

```bash
docker run --rm oitc/modbus-client:latest [options]

usage: modbus_client.py [-h] [-s SLAVE] [-p PORT] [-i SLAVEID]
                        [-t REGISTERTYPE] [-r REGISTER] [-l LENGTH] [-b] [-c]
                        [-d]

Modbus TCP Client v1.0.13

optional arguments:
  -h, --help            show this help message and exit

  -s SLAVE, --slave SLAVE
                        Hostname or IP address of the Modbus TCP slave
                        (default: 127.0.0.1)
  -p PORT, --port PORT  TCP port (default: 502)
  -i SLAVEID, --slaveid SLAVEID
                        The slave ID, between 1 and 247 (default: 1)
  -t REGISTERTYPE, --registerType REGISTERTYPE
                        Register type 1 to 4 to read (1=Discrete Output Coils,
                        2=Discrete Input Contacts, 3=Analog Output Holding
                        Register, 4=Analog Input Register) (default: 3)
  -r REGISTER, --register REGISTER
                        The register address between 0 and 9999 (default: 0)
  -l LENGTH, --length LENGTH
                        How many registers should be read, between 1 and 125
                        (default: 1)
  -b, --bigEndian       Use big endian instead of little endian when
                        calculating the 32bit values
  -c, --csv             Output as CSV
  -d, --debug           Enable debug output

```

```bash
# Read 10 registers from slave
docker run --rm oitc/modbus-client:latest -s 192.168.58.70 -p 1503 -t 4 -r 0 -l 10
           HEX16  UINT16  INT16               BIT       HEX32    FLOAT32
register
30000     0x84D9   34009 -31527  1000010011011001  0x84D90000  -0.000000
30001     0x41ED   16877  16877  0100000111101101  0x41ED84D9  29.689867
30002     0x0000       0      0  0000000000000000  0x000041ED   0.000000
30003     0xC24C   49740 -15796  1100001001001100  0xC24C0000 -51.000000
30004     0x0000       0      0  0000000000000000  0x0000C24C   0.000000
30005     0xBF80   49024 -16512  1011111110000000  0xBF800000  -1.000000
30006     0x0068     104    104  0000000001101000  0x0068BF80   0.000000
30007     0x006C     108    108  0000000001101100  0x006C0068   0.000000
30008     0x0074     116    116  0000000001110100  0x0074006C   0.000000
30009     0x0032      50     50  0000000000110010  0x00320074   0.000000

```

```bash
docker run --rm test:latest -s 192.168.57.10 -p 5020 -t 2 -r 0 -l 3
          BIT   BOOL
register
10000       1   True
10001       0  False
10002       1   True

```