import java.io.*;	//InputStreamReaderやBufferedReaderを使えるようにする宣言
import java.net.*;		//InetAddressやSoket利用のため

public class Client2  {

	public static void main(String argv[]){
		InputStreamReader is = new InputStreamReader(System.in);
		BufferedReader br = new BufferedReader(is);
		byte crlf [] = {13,10};//キャリッジリターン(CR),改行(LF)の並び で、送信時の区切り用

		Socket socket;//ソケット
		
		try {
			System.out.print("接続するサーバーのIPアドレス入力>"); //追加
			String IPAddress = br.readLine(); //キー1行入力
			socket = new Socket( IPAddress ,  80); //接続

			OutputStream os = socket.getOutputStream();
			
			InputStream sok_in = socket.getInputStream();
			InputStreamReader sok_isr = new InputStreamReader(sok_in);
			BufferedReader sok_br = new BufferedReader(sok_isr);

			while(true){
				System.out.print("送信文字列>>");
				String send = br.readLine();	//キー1行入力
				os.write(send.getBytes());//送信
				os.write(crlf);
				os.write(crlf);
				
				String receive = sok_br.readLine();//受信データ取得
				System.out.println("受信『" + receive + "』");
			}
		}
		catch(Exception e){
			System.out.println(e.toString());
		}
		System.out.print("  Enterキーで終了");
		try{System.in.read();}catch(Exception e){}
	}
}