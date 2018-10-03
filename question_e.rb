require 'openssl'
require 'byebug'

@run_time_histroy = {}
def generate_data(size)
  return 'a' * size
end

def rsa_encrypt_and_decrypt(file_arr)
  file_arr.each do |file|
    size = file[1].size
    # Create Key
    start_time = Time.now
    pkey = OpenSSL::PKey::RSA.new(2048)
    end_time = Time.now
    time = (end_time - start_time) * 1000
    @run_time_histroy["RSA-2048-key-generate"] = time

    # Create signature
    start_time = Time.now
    signature = pkey.sign_pss("SHA256", file[1], salt_length: :max, mgf1_hash: "SHA256")
    end_time = Time.now
    time = (end_time - start_time) * 1000
    @run_time_histroy["#{file[0]}-signature-create"] = time

    # Validate signature
    start_time = Time.now
    pub_key = pkey.public_key
    pub_key.verify_pss("SHA256", signature, file[1],
                     salt_length: :auto, mgf1_hash: "SHA256")
    end_time = Time.now
    time = (end_time - start_time) * 1000
    @run_time_histroy["#{file[0]}-signature-validate"] = time
    @run_time_histroy["#{file[0]}-signature-validate-per-byte"] = time / size

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

rsa_encrypt_and_decrypt([['file_1K', file_1K], ['file_1M', file_1M]])
export_runtime
