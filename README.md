# SQLLedger with Docker
This is a Dockerfile to run SQL-Ledger.

 
## Setup
1. Clone Repository
2. run `docker build -t ledger .`
3. Run docker container with `docker run --name=docker_ledger -it -p 8082:8082 --mount type=bind,source=/Users/YOUR_USER/runmyaccounts,target=/home/runmyaccounts --rm ledger`
4. Run `sudo /usr/sbin/httpd`
5. Instance should be available via `localhost:8082/runmyaccounts`

### Some useful commands: 

* Edit Apache configuration  
`sudo vi /etc/httpd/conf/httpd.conf`

* Restart Apache  
`sudo /usr/sbin/httpd -k restart`

* Access log files:  
`sudo -i`  
`cd /var/log/httpd`  
`tail -n 200 -f error_log`
  

## Setup Local Postgres to accept docker connection
1. Open postgresql.conf (can be found by executing: `sudo -U postgres psql -c 'SHOW config_file'`)
    1. Change `listen_addresses` to `'*'`
2. Get your local ip with `ipconfig getifaddr en0` (The interface can change, but its generally en0 on mac)
3. Open pg-hba.conf (Should be in the same folder as postgresql.conf)
    1. Add a new entry (IP should look like this: `192.168.1.1/24` (24 can change too, but should generally work)):  
    
         | Type    | Database    | User    | Address    | Method  |
         | ------ | ---------- | ------ | ------------ |-------- |
         | host   | all        | all    | ip/24        | trust  |

     2. Restart DB Service

4. Now postgres accepts connections from different locations like docker.
   You can test this by connecting to it by executing this command in docker:
   `psql -U rma -h ip -p 5432 phoenix_core`
   `psql -U sql-ledger -h ip -p 5432 development1`

5. You might have to edit the sql-ledger connections in [admin.pl](http://localhost:8082/runmyaccounts/admin.pl)  that are already there. 
   - You have to change the ip address of the db sql-ledger connects to.
   Change in under **every user**  change localhost -> `host.docker.internal`
   You can generally use docker alias mentioned above as the ip.
   - Change it for all the users inc tools@.. rma@.. etc.
   - Why? So, you don't have to change them all the time when your ip changes.
  

### Local access to ledger src

1. You have to check out sql ledger branch into following folder: `/home/runmyaccounts`
   For me, it was `/Users/YOUR_USER/runmyaccounts/runmyaccounts` only then run the docker run command otherwise 
   you will get ledger exception that mention something about  
    - `could not connect to server: Connection refused
      Is the server running on host “localhost” (127.0.0.1) and accepting
      TCP/IP connections on port 5432?
      could not connect to server: Cannot assign requested address
      Is the server running on host “localhost” (::1) and accepting
      TCP/IP connections on port 5432?`
    - `Zugriff fehlgeschlagen!:` on login page

## Issues that need to be fixed
Currently, the container cannot run in the background and httpd doesnt start automatically.
This should be fixed by adding an Entrypoint or CMD line (Commented in the DockerFile), 
but the issue with that is, that the Container doesn't continue running.


## TODOs

- [ ] Align apache configuration to be a like prod 
- [ ] Align ledger configuration to as must as possible alike prod
