import java.io.*;
import java.net.*; //ServerSocket Class are defined
import java.util.*;

public class sample_server2
{
    //PORT Number
    public static final int PORT = 10000; //待ち受けポート番号

    public static void main(String[] args)
    {
        sample_server2 sm = new sample_server2();

        try{
            ServerSocket ss = new ServerSocket(PORT);

            System.out.println("Waiting now ...");
            while(true){
                try{
                    //サーバー側ソケット作成
                    Socket sc = ss.accept();
                    System.out.println("Welcom!");

                    ConnectToClient cc= new ConnectToClient (sc);
                    cc.start();
                }
                catch(Exception ex)
                {
                    ex.printStackTrace();
                    break;
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }
}

//java.lang Package
class ConnectToClient extends Thread
{
    private Socket sc;
    private BufferedReader br;
    private PrintWriter pw;

    //コンストラクタ
    public Client(Socket s)
    {
        sc = s;
    }

    //スレッド実行
    public void run()
    {
        try{
            //クライアントから送られてきたデータを一時保存するバッファ（受信バッファ）
            br = new BufferedReader(new InputStreamReader(sc.getInputStream()));
            //サーバがクライアントへ送るデータを一時保存するバッファ（送信バッファ）
            pw = new PrintWriter(new BufferedWriter(new OutputStreamWriter(sc.getOutputStream())));
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        while(true){
            try{
                //受信バッファからデータを読み込む（今回は文字列）
                String str = br.readLine();
                System.out.println(str);
                Random rnd = new Random();
                RamdomStrings rs = new RamdomStrings();
                //クライアントからのメッセージの語尾＋ランダムな文字配列を送信バッファへ渡す
                pw.println("Server : [" + str.charAt(str.length()-1) + rs.GetRandomString(rnd.nextInt(10)) + "] (^_^)!");
                //ここが重要！flushメソッドを呼ぶことでソケットを通じてデータを送信する
                pw.flush();
            }
            catch(Exception e){
                try{
                    br.close();
                    pw.close();
                    sc.close();
                    System.out.println("Good Bye !!");
                    break;
                }
                catch(Exception ex){
                    ex.printStackTrace();
                }

            }
        }
    }
}

class RamdomStrings{
    private final String stringchar = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private Random rnd = new Random();
    private StringBuffer sbf = new StringBuffer(15); 

    public String GetRandomString(int cnt){
        for(int i=0; i<cnt; i++){
            int val = rnd.nextInt(stringchar.length());
            sbf.append(stringchar.charAt(val));
        }

        return sbf.toString();
    }
}