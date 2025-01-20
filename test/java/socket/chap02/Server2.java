import java.io.*;	//InputStreamReaderやBufferedReaderを使えるようにする宣言
import java.net.*;	//InetAddressやSoket利用のため

public class Server2 {

	public static void main(String argv[]){
		InputStreamReader is = new InputStreamReader(System.in);
		BufferedReader br = new BufferedReader(is);
		byte crlf [] = {13,10};//キャリッジリターン(CR),改行(LF)の並び で、送信時の区切り用


		try {
			//サーバー接続
			InetAddress local = InetAddress.getLocalHost();//このマシンの情報取得
			String localAdr = local.getHostAddress();
			System.out.println("このマシンのIPアドレス" + localAdr);	
			
			//サーバー用ソケットをポート80で作成
			ServerSocket serverSock = new ServerSocket(80); 

			//クライアントからの接続を待ち、接続してきたら、
			//	そのクライアントと通信するソケットを取得する。
			Socket clientSock = serverSock.accept();
			serverSock.close();
			
			//クライアントからのリクエストメッセージ送信情報を受信して表示
			InputStream sok_in = clientSock.getInputStream();
			InputStreamReader sok_is = new InputStreamReader(sok_in);
			BufferedReader sok_br = new BufferedReader(sok_is);
			
			OutputStream os = clientSock.getOutputStream();
			
			while(true){ 
				String receive =  sok_br.readLine();//受信データ取得
				System.out.println(receive);
				receive =  sok_br.readLine();//受信データ取得
				System.out.println(receive);
				System.out.print("送信文字列>>");
				String send = br.readLine();	//キー1行入力
				os.write(send.getBytes());//送信
				os.write(crlf);
			}
		}
		catch(Exception e){
			System.out.println(e.toString());
		}
		System.out.print("  Enterキーで終了");
		try{System.in.read();}catch(Exception e){}
	}
}