#ifndef _SOCKET_H
#define _SOCKET_H
#includestring


#ifdef _WIN32
#	includewinsock.h
#	includeFCNTL.h
#	includeio.h
	typedef int socklen_t;
#	pragma comment(lib, ws2_32.lib)
#else
#	include netdb.h
#	include syssocket.h
#	include systypes.h
#	include sysioctl.h
#	include netinetin.h
#	include netinettcp.h
#	include arpainet.h
#	define closesocket close
	typedef int SOCKET;
#endif
#ifndef INVALID_SOCKET
#	define INVALID_SOCKET  (~0)
#endif
#ifndef SOCKET_ERROR
#	define SOCKET_ERROR -1
#endif


 �o�C�g�I�[�_�[
#ifndef BYTE_ORDER
#	define LITTLE_ENDIAN 1234
#	define BIG_ENDIAN    4321
#	define PDP_ENDIAN    3412
#	if defined(i386)  defined(_WIN32)
#		define BYTE_ORDER LITTLE_ENDIAN
#	endif
#	ifdef __APPLE__
#		define BYTE_ORDER BIG_ENDIAN
#	endif
#endif
#ifndef BYTE_ORDER
#	pragma message(BYTE_ORDER is not defined! (LITTLE_ENDIAN mode))
#	define BYTE_ORDER LITTLE_ENDIAN
#endif

 �l�b�g���[�N�o�C�g�I�[�_
#ifndef NETWORK_BYTE_ORDER
#	define NETWORK_BYTE_ORDER BIG_ENDIAN
#endif


#ifdef _WIN32
#ifndef NOIMP
class WinsockInit
{
	 singleton
	static WinsockInit instance;
	WinsockInit() {
		WSADATA wsadata;
		WSAStartup(MAKEWORD(1, 1), &wsadata);
	}
	
	~WinsockInit() {
		WSACleanup();
	}
};
WinsockInit WinsockInitinstance;
#endif
#endif

 PDP���Ή�w
#if NETWORK_BYTE_ORDER != BYTE_ORDER
static inline long NN(long x_){
	unsigned long x = x_;
	x = x  16  x  16;
	return ((x & 0xff00ff00)  8)  ((x&0x00ff00ff)  8);
}
static inline short NN(short x){
	return (x8)  (x8);
}
#else
templateT
static inline T NN(T x){
	return x;
}
#endif


class Socket{
public
	SOCKET m_socket;
	Socket(const SOCKET &soc){m_socket = soc;}
	Socket(const stdstring &host,short port){
		m_socket=socket(AF_INET, SOCK_STREAM, 0);
		connect(host,port);
	}
	Socket(){m_socket=socket(AF_INET, SOCK_STREAM, 0);}

	static bool getaddr(const stdstring &host, in_addr addr) {
		hostent he;
	    he = gethostbyname(host.c_str());
		if(!he)
			he = gethostbyaddr(host.c_str(), 4, AF_INET);
		if(!he)
		    return false;

		addr=(in_addr)he-h_addr_list;
		return true;
	}

	static stdstring ipstr(const stdstring &host){
		stdstring s;

		struct hostent phe = gethostbyname(host.c_str());
		if (!phe) return s;
		s=inet_ntoa((in_addr)(phe-h_addr_list[0]));

		return s;
	}

	static stdstring myhostname(){
		stdstring s;
		char host[80];
		if (gethostname(host, sizeof(host)) == SOCKET_ERROR) {
			return s;
		}
		s=host;
		return s;
	}

	bool connect(const stdstring &host,short port){
		if(m_socket==INVALID_SOCKET)
			return false;

		hostent he;
		sockaddr_in addr;
		in_addr inaddr;

		if (!getaddr(host, &inaddr))
			return false;

		memset (&addr, 0, sizeof(addr));
		addr.sin_family = AF_INET;
		addr.sin_port = htons(port);
		addr.sin_addr = inaddr;

		if(connect(m_socket, (sockaddr)&addr, sizeof(addr))!=0) {
			m_socket=INVALID_SOCKET;
			return false;
		}
		return true;
	}
	void close(){
		if (m_socket!=INVALID_SOCKET) {
			closesocket(m_socket);
			m_socket=INVALID_SOCKET;
		}
	}

	int send(const void buf,size_t len){
		int ret=send(m_socket,(const char)buf,len,0);
		if (ret1) close();
		return ret;
	}
	int recv(void buf,size_t len){
		int ret=recv(m_socket, (char)buf, len, 0);
		if (ret1) close();
		return ret;
	}


	bool readable() const {
		timeval tv={0,1};
		fd_set fds;
		FD_ZERO(&fds);
		FD_SET(m_socket, &fds);
		
		select((int)m_socket+1, &fds, NULL, NULL, &tv);
		
		return FD_ISSET(m_socket, &fds)!=0;
	}
	bool writable() const {
		timeval tv={0,1};
		fd_set fds;
		FD_ZERO(&fds);
		FD_SET(m_socket, &fds);
		
		select((int)m_socket+1, NULL, &fds, NULL, &tv);
		
		return FD_ISSET(m_socket, &fds)!=0;
	}

	int write(const stdstring &s){
		return send(s.c_str(),s.size());
	}

	stdstring& read(stdstring &s){
		s.clear();
		char c;
		while (recv(&c,1)) {
			s.push_back(c);
			if ( c=='0'  c=='n' ) break;
		}
		return s;
	}
	stdstring read(){
		stdstring s;
		return read(s);
	}


	int writeInt(long d){
		d=NN(d);
		return send(&d,sizeof(d));
	}
	int writeShort(short d){
		d=NN(d);
		return send(&d,sizeof(d));
	}
	int writeByte(char d){
		return send(&d,sizeof(d));
	}

	int writeStr(const stdstring &s){
		return send(s.c_str(),s.size()+1);
	}
	int writeLine(const stdstring &s){
		return send(s.c_str(),s.size())+send(n,1);
	}

	int readInt(){
		long d;
		recv(&d,sizeof(d));
		return NN(d);
	}
	int readShort(){
		short d;
		recv(&d,sizeof(d));
		return NN(d);
	}
	int readByte(){
		char d;
		recv(&d,sizeof(d));
		return d;
	}

	int readStr(stdstring &s,char d='0',int len=0){
		s.clear();
		char c;
		while (recv(&c,1) && c!='0' && c!=d) {
			s.push_back(c);
			if (s.size()==len) break;
		}
		return 0;
	}
	stdstring readStr(char d='0',int len=0){
		stdstring s;
		readStr(s,d,len);
		return s;
	}

	int readLine(stdstring &s,int len=0){
		return readStr(s,'n',len);
	}
	stdstring readLine(){
		return readStr('n');
	}

	bool error() const{
		if (m_socket==INVALID_SOCKET)
			return true;
		return false;
	}
	bool poll() const{return readable();}

	int setsockopt(int optname, const void optval, socklen_t vallen){
		return setsockopt(m_socket, IPPROTO_TCP, optname, (char)optval, vallen);
	}

	operator SOCKET(){return m_socket;}
};

class SocketServer{
	sockaddr_in m_addr;
public
	Socket soc;
	SocketServer(int port,int clients=0){
		int f=1;
		setsockopt(soc.m_socket, SOL_SOCKET
			, SO_REUSEADDR, (const char)&f, sizeof(f));

		memset(&m_addr, 0, sizeof(m_addr));
		m_addr.sin_family=PF_INET;
		m_addr.sin_port=htons(port);

		if(bind(soc.m_socket, (sockaddr)&m_addr, sizeof(m_addr))!=0) {
			soc.close();
			return;
		}
		
		if(listen(soc.m_socket, clients)!=0){
			soc.close();
			return;
		}
	}

	Socket accept(){
		socklen_t addrsize=sizeof(m_addr);
		return Socket(accept(soc.m_socket, (sockaddr)&m_addr, &addrsize));
	}

	bool poll() const{return soc.readable();}
	bool accepted() const{return soc.readable();}
	bool error() const{return soc.error();}
};


#endif
