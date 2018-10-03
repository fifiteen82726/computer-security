require 'openssl'
require 'openssl/oaep'

data = "Sign me!"
pkey = OpenSSL::PKey::RSA.new(2048)
signature = pkey.sign_pss("SHA256", data, salt_length: :max, mgf1_hash: "SHA256")
pub_key = pkey.public_key
puts pub_key.verify_pss("SHA256", signature, data,
                        salt_length: :auto, mgf1_hash: "SHA256") # => true
