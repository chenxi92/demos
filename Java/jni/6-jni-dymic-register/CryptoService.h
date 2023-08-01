//
//  CryptoService.h
//  Karma SDK
//
//  Created by Peak on 2023/8/1.
//

#ifndef CryptoService_h
#define CryptoService_h

#include <stdio.h>
#include <iostream>
#include <vector>
#include <string>

using namespace std;

namespace CryptoService {

class RC4 {
public:
    static string encrypt(string data, string key);
    static string decrypt(string data, string key);

private:
    static vector<unsigned char> keySchedule(string key);
    static string rc4(string data, const vector<unsigned char> &s);
    static string toHex(string data);
    static string fromHex(string data);
};


class XOR {
public:
    static string encrypt(string data, string key);
    static string decrypt(string data, string key);
};


class KeyBuilder {
public:
    static string build(string tag);
};


}

#endif /* CryptoService_h */
