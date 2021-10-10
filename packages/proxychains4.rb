require 'package'

class Proxychains4 < Package
  description 'https://github.com/rofl0r/proxychains-ng/'
  homepage 'https://github.com/rofl0r/proxychains-ng/'
  @_ver = '4.15'
  version @_ver
  license 'GPL-2'
  compatibility 'all'
  source_url 'https://github.com/rofl0r/proxychains-ng.git'
  git_hashtag 'v' + @_ver

  def self.prebuild
    system 'curl -#LO https://salsa.debian.org/debian/proxychains-ng/-/raw/debian/4.15-1/debian/proxychains4.1'
    abort 'Checksum mismatch. :/ Try again.'.lightred unless Digest::SHA256.hexdigest( File.read("proxychains4.1") ) == 'efaed994b933e05a56ab271cff65afae48659cdd5de1b8554aeb4a3766a6fce5'
  end

  def self.build
    system "#{CREW_ENV_OPTIONS} ./configure --prefix=#{CREW_PREFIX} --libdir=#{CREW_LIB_PREFIX}"
    system 'make'
  end

  def self.install
    system 'make', "DESTDIR=#{CREW_DEST_DIR}", 'install'
    system 'make', "DESTDIR=#{CREW_DEST_DIR}", 'install-config'
    FileUtils.mkdir_p "#{CREW_DEST_MAN_PREFIX}/man1"
    FileUtils.install 'proxychains4.1', "#{CREW_DEST_MAN_PREFIX}/man1/proxychains4.1", mode: 0644
  end
end
