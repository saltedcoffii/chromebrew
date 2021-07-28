require 'package'

class Libbsd < Package
  description 'This library provides useful functions commonly found on BSD systems, and lacking on others like GNU systems, thus making it easier to port projects with strong BSD origins, without needing to embed the same code over and over again on each project.'
  homepage 'https://libbsd.freedesktop.org/wiki'
  @_ver = '0.11.2'
  version @_ver
  license 'BSD, BSD-2, BSD-4, ISC'
  compatibility 'all'
  source_url "https://libbsd.freedesktop.org/releases/libbsd-#{@_ver}.tar.xz"
  source_sha256 '9a7fbe60924d40ce4322a00b6f70be07b3704479b2bca1210dd1564924930ff5'

  def self.build
    system "#{CREW_ENV_OPTIONS} ./configure #{CREW_OPTIONS}"
    system "make"
  end

  def self.install
    system "make", "DESTDIR=#{CREW_DEST_DIR}", "install"
  end
end
