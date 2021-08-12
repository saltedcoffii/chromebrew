require 'package'
require 'mkmf'

class Pypy3_exe < Package
  description 'A compliant implementation of Python, running up to 4.2x faster than the reference implementation. - Executable'
  homepage 'https://www.pypy.org/'
  @_ver = '7.3.5'
  version @_ver
  license 'MIT'
  compatibility 'all'
  source_url 'https://salsa.debian.org/debian/pypy3.git'
  git_hashtag 'upstream/' + @_ver + '+dfsg'

  def self.prebuild
    case ARCH
    when 'x86_64'
      @_pypy_file = "pypy2.7-v7.3.5-linux64.tar.bz2"
      @_pypy_sha256 = '4858b347801fba3249ad90af015b3aaec9d57f54d038a58d806a1bd3217d5150'
    when 'i686'
      @_pypy_file = "pypy2.7-v7.3.5-linux32.tar.bz2"
      @_pypy_sha256 = '35bb5cb1dcca8e05dc58ba0a4b4d54f8b4787f24dfc93f7562f049190e4f0d94'
    end

    @_tmpdir = "#{Dir.pwd}/tmpdir"
    FileUtils.mkdir_p @_tmpdir
    # Download and install a pypy binary for supported systems
    case ARCH
    when 'x86_64', 'i686'
      unless `which pypy2 2> /dev/null`.to_s.empty?
        puts 'Found a pypy2 binary in your path, not downloading a new one.'.lightblue
        @_epython = "env TMPDIR=#{@_tmpdir} PYPY_GC_MAX_DELTA=200MB #{`which pypy2`} --jit loop_longevity=300"
      else
        Dir.mkdir 'pypy_tmp'
        Dir.chdir 'pypy_tmp' do
          puts 'Could not find a pypy2 executable in your path.'.lightgreen
          puts 'Downloading pypy executable to build against.'.lightgreen
          system "curl -#LO https://downloads.python.org/pypy/#{@_pypy_file}"
          abort 'Checksum mismatch :/ try again'.lightred unless Digest::SHA256.hexdigest( File.read("#{@_pypy_file}") ) == @_pypy_sha256
          puts 'Unpacking archive'.lightgreen
          system "tar --strip-components=1 -xf #{@_pypy_file}"

          @_epython = "env TMPDIR=#{@_tmpdir} PYPY_GC_MAX_DELTA=200MB #{Dir.pwd}/bin/pypy --jit loop_longevity=300" # Ensures that self.build doesn't swap and hang
        end
      end
    when 'armv7l', 'aarch64'
      unless `which pypy2 2> /dev/null`.to_s.empty?
        puts 'Found a pypy2 executable in your path. Using pypy2 to build.'
        @_epython = "env TMPDIR=#{@_tmpdir} PYPY_GC_MAX_DELTA=200MB #{`which pypy2`} --jit loop_longevity=300"
      else
        puts 'Could not find a pypy2 executable in your path.'.lightgreen
        puts 'WARNING: No precompiled pypy2 binary available for your architecture'.lightgreen
        puts 'You are building without a preexisting pypy executable.'.orange
        puts 'If you do not have at least 4 GB of FREE RAM, this build will likely hang.'.orange
        @_epython = "env TMPDIR=#{@_tmpdir} #{`which python2`}"
      end
    end
  end

  def self.build
    system "#{@_epython} rpython/bin/rpython --batch \
             --source \
             --no-shared \
             -Ojit --jit-backend=auto \
             --cc=#{CREW_TGT}-gcc \
             --make-jobs=#{CREW_NPROC} \
             --verbose \
             pypy/goal/targetpypystandalone \
             --withmod-bz2 \
             --withmod-_minimal_curses \
             --withmod-pwd \
             --withmod-zlib"
    system "make -C #{@_tmpdir}"
  end

  def self.install
    FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/bin/"
    FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/include/pypy3.7/"
    FileUtils.cp Dir.glob("#{@_tmpdir}/pypy3-c"), "#{CREW_DEST_PREFIX}/bin/pypy3.7"
    FileUtils.cp Dir.glob("include/*"), "#{CREW_DEST_PREFIX}/include/pypy3.7/"
    FileUtils.symlink 'pypy3.7', "#{CREW_DEST_PREFIX}/bin/pypy3"
    FileUtils.symlink 'pypy3.7', "#{CREW_DEST_PREFIX}/bin/pypy"
  end
end
