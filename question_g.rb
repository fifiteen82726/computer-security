require 'openssl'
require 'digest'
require 'byebug'
# Create a 2048-bit DSA key, sign the two files and verify the corresponding signatures.
# If creating a key takes two parameters, use 224 bits for the exponent sizes. If the hash
# function algorithm needs to specified separately, use SHA-256.

# 2048 DSA SHA-256.
@run_time_histroy = {}
def generate_data(size)
  return 'a' * size
end

def dsa_sign_and_verify(file_arr, key_size)
  file_arr.each do |file|
    size = file[1].size
    start_time = Time.now
    dsa = OpenSSL::PKey::DSA.new(key_size)
    end_time = Time.now
    time = (end_time - start_time) * 1000
    pub_key = dsa.public_key
    pub_key_der = pub_key.to_der
    @run_time_histroy["DSA-#{key_size}-key-generate"] = time

    start_time = Time.now
    digest = Digest::SHA256.digest(file[1])
    sig = dsa.syssign(digest)
    end_time = Time.now
    time = (end_time - start_time) * 1000
    @run_time_histroy["DSA-#{key_size}-#{file[0]}-signature-generate"] = time
    @run_time_histroy["DSA-#{key_size}-#{file[0]}-signature-generate-per-byte"] = time / size

    start_time = Time.now
    puts dsa.sysverify(digest, sig)
    end_time = Time.now # => true
    time = (end_time - start_time) * 1000
    @run_time_histroy["DSA-#{key_size}-#{file[0]}-signature-validate"] = time
    @run_time_histroy["DSA-#{key_size}-#{file[0]}-signature-validate-per-byte"] = time / size
  end
end

def export_runtime
  @run_time_histroy.each do |k, v|
    p (k + (" %f" % v.to_s))
  end
end


file_1K = generate_data(10**3)
file_1M = generate_data(10**6)
dsa_sign_and_verify([['file_1K', file_1K], ['file_1M', file_1M]], 2048)
dsa_sign_and_verify([['file_1K', file_1K], ['file_1M', file_1M]], 3072)
export_runtime
