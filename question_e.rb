require 'openssl'
require 'byebug'

@run_time_histroy = {}
def generate_data(size)
  return 'a' * size
end

def rsa_encrypt_and_decrypt(file_arr, key_size)
  file_arr.each do |file|
    size = file[1].size
    # Create Key
    start_time = Time.now
    pkey = OpenSSL::PKey::RSA.new(key_size)
    end_time = Time.now
    time = (end_time - start_time) * 1000
    @run_time_histroy["RSA-2048-key-generate"] = time

    # Encrypt, divide into chunk, block size = 16 bytes
    start_time = Time.now
    chunks = file[1].scan(/.{1,16}/)
    cipher_block = chunks.map do |i|
      pkey.private_encrypt(i)
    end
    end_time = Time.now
    time = (end_time - start_time) * 1000
    @run_time_histroy["#{file[0]}-encrypt"] = time
    @run_time_histroy["#{file[0]}-encrypt-per-byte"] = time / size

    # Decrypt, decrypt each block
    start_time = Time.now
    plain_text = cipher_block.map do |i|
      pkey.public_decrypt(i)
    end

    end_time = Time.now
    time = (end_time - start_time) * 1000
    @run_time_histroy["#{file[0]}-decrypt"] = time
    @run_time_histroy["#{file[0]}-decrypt-per-byte"] = time / size
  end
end

def export_runtime
  @run_time_histroy.each do |k, v|
    p (k + (" %f" % v.to_s))
  end
end

file_1K = generate_data(10**3)
file_1M = generate_data(10**6)

rsa_encrypt_and_decrypt([['file_1K', file_1K], ['file_1M', file_1M]], 2048)
rsa_encrypt_and_decrypt([['file_1K', file_1K], ['file_1M', file_1M]], 3072)
export_runtime
