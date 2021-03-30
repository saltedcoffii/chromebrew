require 'package'

class Ncursesw < Package
  description 'The ncurses (new curses) library is a free software emulation of curses in System V Release 4.0 (SVr4), and more. — Wide character'
  homepage 'https://www.gnu.org/software/ncurses/'
  version '6.2-20210206-2'
  license 'MIT'
  compatibility 'all'
  source_url 'https://github.com/mirror/ncurses/archive/b724cdc89cf31757ab43262ecefe5242b0edc450.zip'
  source_sha256 'e5e83965329c85d8d28f9a35a71ab785fce015f42f491e7dcafbb9f36ad1eaea'

  def self.build
    # build libncursesw
    FileUtils.mkdir 'ncursesw_build'
    Dir.chdir 'ncursesw_build' do
      system "env CFLAGS='-flto=auto' \
          CXXFLAGS='-flto=auto' \
          LDFLAGS='-flto=auto' \
        ../configure #{CREW_OPTIONS} \
          --program-prefix='' \
          --program-suffix='' \
          --with-shared \
          --with-cxx-shared \
          --without-debug \
          --enable-pc-files \
          --with-pkg-config-libdir=#{CREW_LIB_PREFIX}/pkgconfig \
          --enable-widec \
          --without-tests \
          --with-termlib"
      system 'make'
    end
  end

  def self.install
    Dir.chdir 'ncursesw_build' do
      system 'make', "DESTDIR=#{CREW_DEST_DIR}", 'install'
    end
  end
end
