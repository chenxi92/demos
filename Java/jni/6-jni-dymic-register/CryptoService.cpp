//
//  CryptoService.cpp
//  KMUtil
//
//  Created by peak on 2023/8/1.
//

#include "CryptoService.h"
#include <sstream>
#include <iomanip>

using namespace CryptoService;

// RC4
string RC4::encrypt(string data, string key)
{
    if (key.empty()) {
        key = KeyBuilder::build("rc4");
    }
    string encrypted = rc4(data, keySchedule(key));
    return toHex(encrypted);
}

string RC4::decrypt(string encrypted_data, string key)
{
    if (key.empty()) {
        key = KeyBuilder::build("rc4");
    }
    string edcrypted = fromHex(encrypted_data);
    return rc4(edcrypted, keySchedule(key));
}

std::vector<unsigned char> RC4::keySchedule(string key)
{
    std::vector<unsigned char> s(256);
    for(int i = 0; i < 256; i++) {
        s[i] = i;
    }

    int j = 0;
    for(int i = 0; i < 256; i++) {
        j = (j + s[i] + key[i % key.size()]) % 256;
        std::swap(s[i], s[j]);
    }

    return s;
}

string RC4::rc4(string data, const vector<unsigned char> &s)
{
    std::string result;
    int i = 0, j = 0;
    std::vector<unsigned char> s_copy = s;

    for(char c : data) {
        i = (i + 1) % 256;
        j = (j + s_copy[i]) % 256;
        unsigned char temp = s_copy[i];
        s_copy[i] = s_copy[j];
        s_copy[j] = temp;
        result += c ^ s_copy[(s_copy[i] + s_copy[j]) % 256];
    }

    return result;
}

string RC4::toHex(string data) {
    static const char hex[] = "0123456789abcdef";
    string result;

    for(char c : data) {
        result += hex[(c >> 4) & 0xF];
        result += hex[c & 0xF];
    }

    return result;
}

string RC4::fromHex(string data) {
    string result;
    for(size_t i = 0; i < data.size(); i += 2) {
        char c = (data[i] >= 'a' ? data[i] - 'a' + 10 : data[i] - '0') << 4;
        c += data[i + 1] >= 'a' ? data[i + 1] - 'a' + 10 : data[i + 1] - '0';
        result += c;
    }
    return result;
}

// XOR
string XOR::encrypt(string data, string key)
{
    if (key.empty()) {
        key = KeyBuilder::build("xor");
    }
    string result = "";
    int len = (int)data.length();
    int keyLen = (int)key.length();
    for (int i = 0; i < len; i++) {
        char c = data[i] ^ key[i % keyLen];
        result += c;
    }
    
    // Convert result string to a hexadecimal string
    stringstream ss;
    ss << std::hex << std::setfill('0');
    for (unsigned char c : result) {
        ss << std::setw(2) << static_cast<int>(c);
    }
    return ss.str();
}

string XOR::decrypt(string data, string key)
{
    if (key.empty()) {
        key = KeyBuilder::build("xor");
    }
    
    string result = "";
    string hexByte = "";
    int len = (int)data.length();
    int keylen = (int)key.length();
    for (int i = 0; i < len; i++) {
        if ((i % 2) == 0) {
            hexByte = data.substr(i, 2);
            int value;
            stringstream ss;
            ss << std::hex << hexByte;
            ss >> value;
            result += static_cast<char>(value ^ key[i/2 % keylen]);
        }
    }
    return result;
}

// Key Builder
string KeyBuilder::build(string tag) {
    return "karma.sdk." + tag + ".encrypt";
}
