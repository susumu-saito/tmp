#!/usr/bin/ruby

require "socket"

# ポート番号20000番でopen
s0 = TCPServer.open(20000)

# クライアントからの接続を受け付ける
sock = s0.accept

# クライアントからのデータを最後まで受信する
# 受信したデータはコンソールに表示される
while buf = sock.gets
  p buf
end

# クライアントとの接続ソケットを閉じる
sock.close

# 待ちうけソケットを閉じる
s0.close