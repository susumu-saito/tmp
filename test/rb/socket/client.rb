#!/usr/bin/ruby

require "socket"

# 127.0.0.1(localhost)の20000番へ接続
sock = TCPSocket.open("127.0.0.1", 20000)

# HELLOという文字列を送信
sock.write("HELLO")

# 送信が終わったらソケットを閉じる
sock.close