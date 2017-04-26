require 'openssl'
require 'digest'
require 'base64'

module Keen
  class AESHelper

    class << self
      def aes256_decrypt(key, iv_plus_encrypted)
        puts 'start dec'
        aes = OpenSSL::Cipher::AES.new(256, :CBC)
        puts 'create cipher'
        iv = iv_plus_encrypted[0, aes.key_len]
        puts 'create iv'
        encrypted = iv_plus_encrypted[aes.key_len, iv_plus_encrypted.length]
        puts 'get encrypted'
        aes.decrypt
        puts 'decrypt'
        aes.key = unhexlify(key)
        puts 'set key'
        aes.iv = unhexlify(iv)
        puts 'set iv'
        aes.update(unhexlify(encrypted)) + aes.final
      end

      def aes256_encrypt(key, plaintext, iv = nil)
        raise OpenSSL::Cipher::CipherError.new("iv must be 16 bytes") if !iv.nil? && iv.length != 16
        aes = OpenSSL::Cipher::AES.new(256, :CBC)
        aes.encrypt
        aes.key = unhexlify(key)
        aes.iv = iv unless iv.nil?
        iv ||= aes.random_iv
        hexlify(iv) + hexlify(aes.update(plaintext) + aes.final)
      end

      def hexlify(msg)
        msg.unpack('H*')[0]
      end

      def unhexlify(msg)
        [msg].pack('H*')
      end
    end
  end
end
