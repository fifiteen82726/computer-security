# 128 AES CBC
require 'openssl'

class MyEncryption
  def initialize(mode, size)
    @run_time_histroy = {}
    @mode = mode
    @size = size
  end

  def encryption_then_decrypt(data, file_name)
    size = data.size
    # Generate key
    start_time = Time.now
    cipher = OpenSSL::Cipher::AES.new(@size, @mode)
    cipher.encrypt
    key = cipher.random_key
    end_time = Time.now
    time = (end_time - start_time) * 1000
    @run_time_histroy["AES-#{@mode}-#{@size}-key-generate"] = time

    # Encrypt
    start_time = Time.now
    iv = cipher.random_iv
    encrypted = cipher.update(data) + cipher.final
    end_time = Time.now
    time = (end_time - start_time) * 1000
    @run_time_histroy["AES-#{@mode}-#{@size}-key-encrypt-#{file_name}"] = time
    @run_time_histroy["AES-#{@mode}-#{@size}-key-encrypt-#{file_name}-per-byte"] = time / size

    # Decrypt
    start_time = Time.now
    cipher.decrypt
    cipher.key = key
    cipher.iv = iv
    plain = cipher.update(encrypted) + cipher.final
    end_time = Time.now
    time = (end_time - start_time) * 1000
    @run_time_histroy["AES-#{@mode}-#{@size}-key-decrypt-#{file_name}"] = time
    @run_time_histroy["AES-#{@mode}-#{@size}-key-decrypt-#{file_name}-per-byte"] = time / size

    return data == plain
  end

  def export_runtime
    @run_time_histroy.each do |k, v|
      p (k + (" %f" % v.to_s))
    end
  end
end

def generate_data(size)
  return 'a' * size
end

def compute_with_different_mode_and_size(combinations)
  combinations.each do |combination|
    myencryption = MyEncryption.new(combination[0], combination[1])

    # Generate 1KB data and do encryption, decryption
    file_1K = generate_data(10**3)
    myencryption.encryption_then_decrypt(file_1K, 'file_1K')

    # Generate 1MB data and do encryption, decryption
    file_1M = generate_data(10**6)
    myencryption.encryption_then_decrypt(file_1M, 'file_1M')
    myencryption.export_runtime
  end
end

combinations = [['CBC', 128], ['CTR', 128], ['CTR', 256]]
compute_with_different_mode_and_size(combinations)
