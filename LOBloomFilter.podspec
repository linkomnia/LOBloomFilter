Pod::Spec.new do |s|
  s.name             = "LOBloomFilter"
  s.version          = "0.1.1"
  s.summary          = "A simple bloom filter using FNV-1a hash."
  s.description      = <<-DESC
                       LOBloomFilter - A simple bloom filter using FNV-1a hash.
                       DESC
  s.homepage         = "https://github.com/linkomnia/LOBloomFilter"
  s.license          = 'MIT'
  s.author           = { "Roger So" => "rogerso@linkomnia.com" }
  s.source           = { :git => "https://github.com/linkomnia/LOBloomFilter.git", :tag => s.version.to_s }

  s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'
  s.requires_arc = true

  s.source_files = 'LOBloomFilter.{h,m}', 'fnv/fnv.h', 'fnv/longlong.h', 'fnv/hash_{32,64}{,a}.c'

  s.public_header_files = 'LOBloomFilter.h', 'fnv/fnv.h', 'fnv/longlong.h'
end
