# SQLLedger with Docker
This is a Dockerfile to run SQL-Ledger.


## Setup
1. Clone Repository
2. run `docker build -t ledger .`
3. Run docker container with `docker run -it -p 8082:8082 --mount source=ledger,target=/home/runmyaccounts --rm ledger`
4. Run `sudo /usr/sbin/httpd`
5. Instance should be available via `localhost:8082/runmyaccounts`


## Issues that need to be fixed
Currently the container cannot run in the background and httpd doesnt start automatically.
This should be fixed by adding an Entrypoint or CMD line (Commented in the DockerFile) but the issue with that is, that the Container doens't continue running.
