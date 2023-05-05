//
//  UDP_network.h
//  Science-gene
//
//  Created by wtnbks on 2017/05/11.
//  Copyright © 2017年 wtnbks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <sys/types.h>

@interface UDP_network : NSObject
{
    CFSocketRef socket_dsc;
    CFDataRef socket_address;
    
    int socket_send_dsc;
    int socket_receive_dsc;
    struct sockaddr_in addr_send;
    struct sockaddr_in addr_receive;
    
    
    NSLock* lock_obj;
    
}
@property ( nonatomic ) char* receiveBuffer;
@property ( nonatomic, readonly ) long receiveBufferSize;
@property ( nonatomic ) int receiveLength;
@property ( nonatomic ) unsigned int sleepInterval;



- (bool)createReceiveSocket:(int)portNumber;
- (bool)createSendSocket:(const char*)IP_ADDRESS port:(int)portNumber;

- (void)receiveLoop:(NSThread*)object;
- (void)sendData:(NSString*)string;
- (void)sendIndex:(int)index;
@end
