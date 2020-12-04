# Docker Container with SSH and Docker

## *TL;DR*

### Spawn-Node

**UNIX**
```bash
$ source ./spawn.sh
$ Spawn-Node YourCoolName
```

**WINDOWS**
```powershell
$ . ./spawn.ps1
$ Spawn-Node YourCoolName
```

### Connect

```bash
$ docker port YourCoolName
22/tcp -> 0.0.0.0:32771
$ ssh -i ./YourCoolName.id -p 32771 ubuntu@localhost
```

## How To

*Set container name variable*

```bash
# Bash
name="TEST"

# Powershell
$name="TEST"
```

*These Commands should work in windows powershell and linux terminal*

```bash
# Build image
$ docker build . --tag "ubuntu:custom"
...
Successfully built d643583d4ccd  
Successfully tagged ubuntu:custom

# Start Container 
$ docker run -d --name "$name" --restart unless-stopped --privileged -p 22 ubuntu:custom
2962b5e8ae66d9c065e0fe507667e0c0b002d557d71a671fa5f8579d698b32ce

# Create Keys
$ docker exec --user ubuntu "$name" "/scripts/keypair.sh"
Agent pid 137   
Identity added: /home/ubuntu/.ssh/id_ed25519 (ubuntu@2962b5e8ae66)

# Copy Key
$ docker cp "$(echo $name):/home/ubuntu/.ssh/id_ed25519" ./$name.id

# Check Key
$ cat ./$name.id
-----BEGIN OPENSSH PRIVATE KEY-----
57VIMaW2NcQdcwfHBWL2K2tYNr6KZmSoOONJ30C9vn8vXjpkABH4vA46mZ0c
jitL8mifC1pxQUHVm3qWN6nZToDXINtsrpmHFob5hVwrBeGbIKF0sDZRWrng
3k56utsVRneRppHgkidI9B87UqTiYdmXjw57TbeKU3UzwCRNIEHvfumOMsTQ
nvBxUjAeZrL43xu8lEfvkn9Y69Qr2nxKmatUqZwOnJVewtGEI1NDybM7AESW
Rp0HUBo4Cn1vUBWulBUGSfKVC43mYauplVgAUGWWhLF4bmJf3hqrzLbLh2cP
gHWI4NfrhxRhdx1eGjpSPiuAypsma0IhKMZrtOGbxgA6akljqswFxyxVH4c8
NpwMVMUDmR9ixcsIjFv5ElAfWgyzQYg1ky6qZSwbY1yUNSpBEZ1eNcgHB0fx
4yF2yG3kuy9YR5ZpXDtdAakSJG5ZEiDupiBHZ4WcUEnRTdpl6sKLlLxqIu7s
cMi8UNWSNLxTw8dQ750B39LUCZQWN2c6sLa5DxpMozt6PwcLybMaWrB5LDgB
pnlxrirpr95zRCPKwLmufG4O3cU9MZ4U9E4swji0X08rrcyAjpuXhVJE8oHA
-----END OPENSSH PRIVATE KEY-----

# get port
$ docker port $name
22/tcp -> 0.0.0.0:32780

# connect via ssh
$ ssh ubuntu@localhost -p 32780 -i ./$name.id
```