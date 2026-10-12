# HTTP Server from Scratch

We normally implement a HTTP server in C by using a TCP socket, which involves the following steps:

1. Create a TCP socket object
2. Bind a name (or more specifically, an address) to this socket object
3. Make this socket object to start listening and waiting for incoming connections
4. When a connection arrive, we accept this connection and we exchange the HTTP messages (HTTP Request and Response)
5. Then, we simply close this connection

A socket object is essentially a channel of communication. You are creatinga a channel where people can send messages through. When you create a socket object, this object is not binded to any particular address.  Which means the channel is not currently available, or is not currently accessible, because it does not have a known address where you can find it.

This is what the "bind" operation does. It binds a name or more specifically, an address, to this socket object, or, this channel of communication, so that it becomes available, or accessible through this address.

An address is defined as an IP address, or more specifically, an IPv4 address. Every IPv4 address is composed by two components. The first component is the host, which is a sequence of 4 numbers separated by dot characters (`.`) that identifies the machine used. While the second component is a port number, which identifies the specific door, or the specific port to use in the host machine.
