//memberClient.c

#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
    struct ip_mreq mreq;
    int serveraddress_len;
    int client_socket;
    struct sockaddr_in serveraddress;
    int serveraddress_len;
    
    //初始化地址
    memset(&serveraddress,0,sizeof(serveraddress));
    serveraddress.sin_family=AF_INET;
    serveraddress.sin_port=htons(5555);
    serveraddress.sin_addr.s_addr=htonl(INADDR_ANY);
    
    if((client_socket=socket(AF_INET,SOCK_DGRAM,0))<0){
        perror("client");
        return 0;
    }
    
    //绑定SOCKET
    if(bind(client_socket,(struct sockaddr*)&serveraddress,sizeof(serveraddress))<0){
        printf("bind");
        return 0;
    }
    
    int opt=1;
    if(setsockopt(client_socket,SOL_SOCKET,SO_REUSEADDR,&opt,sizeof(opt))<0){
        printf("setsockopt1");
        return 0;
    }
    
    //加入多播
    mreq.imr_multiaddr.s_addr=inet_addr("244.0.1.100");
    mreq.imr_interface.s_addr=htonl(INADDR_ANY);
    
    if(setsockopt(client_socket,IPPROTO_IP,IP_ADD_MEMBERSHIP,&mreq,sizeof(mreq))<0){
        perror("setsockopt2");
        return 0;
    }
    
    while(1){
        char buf[200];
        serveraddress_len=sizeof(serveraddress);
        if(recvfrom(client_socket,buf,200,0,(struct sockaddr*)&serveraddress,(socklen_t *)serveraddress_len)<0){
            perror("recvfrom");
        }
        printf("msg from server: %s\n",buf);
        
        if(strcmp(buf,"quit")==0){
            if(setsockopt(client_socket,IPPROTO_IP,IP_DROP_MEMBERSHIP,&mreq,sizeof(mreq))<0){
                perror("setsokopt3");
            }
            close(client_socket);
            return 0;
        }
    }
    
    return 0;
}