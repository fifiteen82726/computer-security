# SHA-256
# SHA-512
# SHA3-256

require 'digest'
require 'digest/sha3'

def generate_data(size)
  return 'a' * size
end

file_1K = generate_data(10**3)
file_1M = generate_data(10**6)

def export_runtime
  @run_time_histroy.each do |k, v|
    p (k + (" %f" % v.to_s))
  end
end

def do_sha256(file_1K, file_1M)
  file_1K_size = file_1K.size
  file_1M_size = file_1M.size

  start_time = Time.now
  Digest::SHA256.digest(file_1K)
  end_time = Time.now
  time = (end_time - start_time) * 1000
  @run_time_histroy["SHA256-file_1K"] = time
  @run_time_histroy["SHA256-file_1K-per-byte"] = time / file_1K_size

  start_time = Time.now
  Digest::SHA256.digest(file_1M)
  end_time = Time.now
  time = (end_time - start_time) * 1000
  @run_time_histroy["SHA256-file_1M"] = time
  @run_time_histroy["SHA256-file_1M-per-byte"] = time / file_1M_size
end

def do_sha512(file_1K, file_1M)
  file_1K_size = file_1K.size
  file_1M_size = file_1M.size

  start_time = Time.now
  Digest::SHA512.digest(file_1K)
  end_time = Time.now
  time = (end_time - start_time) * 1000
  @run_time_histroy["SHA512-file_1K"] = time
  @run_time_histroy["SHA512-file_1K-per-byte"] = time / file_1K_size

  start_time = Time.now
  Digest::SHA512.digest(file_1M)
  end_time = Time.now
  time = (end_time - start_time) * 1000
  @run_time_histroy["SHA512-file_1M"] = time
  @run_time_histroy["SHA512-file_1M-per-byte"] = time / file_1M_size
end

def do_sha_3_256(file_1K, file_1M)
  file_1K_size = file_1K.size
  file_1M_size = file_1M.size

  start_time = Time.now
  Digest::SHA3.digest(file_1K, 256)
  end_time = Time.now
  time = (end_time - start_time) * 1000
  @run_time_histroy["SHA3-256-file_1K"] = time
  @run_time_histroy["SHA3-256-file_1K-per-byte"] = time / file_1K_size

  start_time = Time.now
  Digest::SHA3.digest(file_1K, 256)
  end_time = Time.now
  time = (end_time - start_time) * 1000
  @run_time_histroy["SHA3-256-file_1M"] = time
  @run_time_histroy["SHA3-256-file_1M-per-byte"] = time / file_1M_size
end

@run_time_histroy = {}
do_sha256(file_1K, file_1M)
do_sha512(file_1K, file_1M)
do_sha_3_256(file_1K, file_1M)
export_runtime
