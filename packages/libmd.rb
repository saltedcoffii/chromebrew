require 'package'

class Libmd < Package
  description 'This library provides message digest functions commonly found on BSD systems, and lacking on others like GNU systems.'
  homepage 'https://libbsd.freedesktop.org/wiki'
  @_ver = '1.0.3'
  version @_ver
  license 'BSD, BSD-2, public-domain, BEER-WARE, ISC'
  compatibility 'all'
  source_url "https://libbsd.freedesktop.org/releases/libmd-#{@_ver}.tar.xz"
  source_sha256 '5a02097f95cc250a3f1001865e4dbba5f1d15554120f95693c0541923c52af4a'

  def self.build
    system "#{CREW_ENV_OPTIONS} ./configure #{CREW_OPTIONS}"
    system "make"
  end

  def self.install
    system "make", "DESTDIR=#{CREW_DEST_DIR}", "install"
  end
end
