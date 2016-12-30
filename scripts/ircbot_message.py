#!/usr/bin/env python2

# Four arguments, password host channel and message.
# EG: "ircbot_message.py hunter2 example.com #adminchannel ADMINHELP, people are killing me!"

import sys
import socket

def pack():

    try:
        data = sys.argv[4:]
        print(data)
    except:
        data = "NO DATA SPECIFIED"
    data = str(data)
    data = bytes(data, "ascii")
    nudge(data)

def nudge(data):
    HOST = sys.argv[2]
    PORT = 45678
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((HOST, PORT))
    s.send(data)
    s.close()

if __name__ == "__main__" and len(sys.argv) > 1:  # If not imported and more than one argument
    pack()