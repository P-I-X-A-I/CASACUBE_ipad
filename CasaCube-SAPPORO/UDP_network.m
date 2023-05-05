//
//  UDP_network.m
//  Science-gene
//
//  Created by wtnbks on 2017/05/11.
//  Copyright © 2017年 wtnbks. All rights reserved.
//

#import "UDP_network.h"

@implementation UDP_network

@synthesize receiveBuffer;
@synthesize receiveLength;
@synthesize receiveBufferSize;
@synthesize sleepInterval;
- (id)init
{
    self = [super init];
    
    NSLog(@"UDP_network init");
    
    
    // init variable
    socket_send_dsc = -1;
    socket_receive_dsc = -1;
    
    receiveBufferSize = 256;
    receiveBuffer = (char*)malloc(receiveBufferSize);
    memset( receiveBuffer, 0, receiveBufferSize);
    receiveLength = 0;
    
    lock_obj = [[NSLock alloc] init];
    
    sleepInterval = 1;
    
    return self;
}


- (bool)createReceiveSocket:(int)portNumber
{
    
    // check if socket for reveive is already opened.
    if( socket_receive_dsc != -1 )
    {
        close(socket_receive_dsc);
        socket_receive_dsc = -1;
    }
    
    // create socket
    socket_receive_dsc = socket(AF_INET, SOCK_DGRAM, 0);
    if( socket_receive_dsc == -1 )
    {
        NSLog(@"create socket for receive error.... return");
        return NO;
    }
    
    
    // setup address
    memset(&addr_receive, 0, sizeof(addr_receive));
    addr_receive.sin_len = sizeof(struct sockaddr_in);
    addr_receive.sin_family = AF_INET;
    addr_receive.sin_addr.s_addr = INADDR_ANY;
    addr_receive.sin_port = htons(portNumber);
    
    // bind socket
    int err = bind( socket_receive_dsc, (struct sockaddr*)&addr_receive, addr_receive.sin_len);
    
    if( err )
    {
        NSLog(@"bind receive socket fail....");
        close( socket_receive_dsc );
        socket_receive_dsc = -1;
    }
    
    
    // start receive loop
    [self performSelectorInBackground:@selector(receiveLoop:)
                           withObject:[NSThread currentThread]];
    
    
    
    return YES;
}

- (void)receiveLoop:(NSThread*)thread
{
    char buffer[256];
    while(1)
    {
        receiveBufferSize = recvfrom( socket_receive_dsc, buffer, sizeof(buffer), 0, NULL, 0);
        
        [lock_obj lock];
        memset(receiveBuffer, 0, receiveBufferSize);
        memcpy(receiveBuffer, buffer, 256);
        [lock_obj unlock];
        
        usleep(sleepInterval*1000);
    }
}



- (bool)createSendSocket:(const char *)IP_ADDRESS port:(int)portNumber
{
    // check if socket is already opened
    if( socket_send_dsc != -1 )
    {
        close( socket_send_dsc );
        socket_send_dsc = -1;
    }
    
    
    // create socket
    socket_send_dsc = socket( AF_INET, SOCK_DGRAM, 0 );
    if( socket_send_dsc == -1 )
    {
        NSLog(@"create send socket fail... return");
        return NO;
    }
    
    // setup address
    memset( &addr_send, 0, sizeof(addr_send) );
    addr_send.sin_len = sizeof( addr_send );
    addr_send.sin_family = AF_INET;
    addr_send.sin_port = htons(portNumber);
    addr_send.sin_addr.s_addr = inet_addr(IP_ADDRESS);
    
    return YES;
}


- (void)sendData:(NSString *)string
{
    unsigned long strLen = [string length];
    char* cStr = (char*)[string UTF8String];

   
    unsigned char sendChar[4];

    sendChar[0] = '/';
    sendChar[1] = 'k';
    sendChar[2] = 'o';
    sendChar[3] = 0;
    
    long sendLength = sendto( socket_send_dsc,
                            sendChar,
                            4,
                            0,
                            (struct sockaddr*)&addr_send,
                            sizeof(addr_send)
                            );
    //NSLog(@"%s", sendChar);
}


- (void)sendIndex:(int)index
{
    unsigned char sendChar[16];
    sendChar[0] = '/';
    sendChar[1] = 'c';
    sendChar[2] = 'a';
    sendChar[3] = 0;
    
    sendChar[4] = ',';
    sendChar[5] = 'i';
    sendChar[6] = 0;
    sendChar[7] = 0;
  
    sendChar[8] = 0;
    sendChar[9] = 0;
    sendChar[10] = 0;
    sendChar[11] = (unsigned char)index;
    
    sendChar[12] = 0;
    sendChar[13] = 0;
    sendChar[14] = 0;
    sendChar[15] = 16;
    
    long sendLength = sendto( socket_send_dsc,
                             sendChar,
                             16,
                             0,
                             (struct sockaddr*)&addr_send,
                             sizeof(addr_send)
                             );
    
    NSLog(@"%s", sendChar);
}

@end
