require 'package'

class Pypy2 < Package
  description 'A fast, compliant, JIT compiler and alternative implementation of Python 2.'
  homepage 'https://www.pypy.org/'
  @_py_ver = '2.7'
  @_ver = '7.3.9'
  version @_py_ver + @_ver
  license 'MIT'
  compatibility 'all'
  source_url 'https://downloads.python.org/pypy/pypy2.7-v7.3.9-src.tar.bz2'
  source_sha256 '39b0972956f6548ce5828019dbae12503c32d6cbe91a2becf88d3e42cc52197b'

  # PyPy's buildsystem already has sane, tested optimization, lto, and pic flags
  # We shouldn't mess with these
  no_env_options
  @_envvars = "CFLAGS=\"-fuse-ld=#{CREW_LINKER} #{CREW_LINKER_FLAGS}\" \
               CXXFLAGS=\"${CFLAGS}\""

  depends_on 'expat'
  depends_on 'bz2'
  depends_on 'gdbm'
  depends_on 'openssl'
  depends_on 'libffi'
  depends_on 'zlibpkg'
  depends_on 'ncurses'
  depends_on 'tk' => :build
  depends_on 'sqlite' => :build
  depends_on 'gcc' => :build
  depends_on 'mold' => :build
  depends_on 'rsync' => :build # for moving files around

  # Try to find a pypy2 in the path, if there isn't one, use python2
  if system 'command -v pypy2.7', exception: false
    @_python = "pypy2.7"
  elsif system 'command -v pypy2', exception: false
    @_python = "pypy2"
  elsif system 'command -v pypy', exception: false
    @_python = "pypy"
  else
    depends_on 'python2' => :build
    @_python = 'python2.7'
  end

  def self.patch
    # For some reason, pypy wants to use its own vendored dependencies when detecting linux.
    system "sed -i \"s/, 'linux', 'linux2'//\" pypy/goal/targetpypystandalone"
  end

  def self.build
    puts 'WARNING: Using python2 in lieu of pypy2 for build. This is VERY SLOW.'.yellow if @_python == 'python2.7'
    Dir.chdir 'pypy/goal' do
      # Build PyPy. This will show some fractals while building "because it's cool."
      # Verbosity is enabled for debugging purposes
      system "#{@_envvars} #{@_python} ../../rpython/bin/rpython \
                --opt=jit \
                --shared \
                --lto \
                --verbose \
                targetpypystandalone"
      # Compile binary modules
      system "#{@_envvars} PYTHONPATH=../.. ./pypy-c \
              ../../lib_pypy/pypy_tools/build_cffi_imports.py"
    end
  end

  def self.install
    FileUtils.mkdir_p "#{CREW_DEST_LIB_PREFIX}/pypy/bin/"
    FileUtils.install 'pypy/goal/pypy-c', "#{CREW_DEST_LIB_PREFIX}/pypy/bin/pypy2", mode: 0o755
    FileUtils.install 'pypy/goal/libpypy-c.so', "#{CREW_DEST_PREFIX}/pypy/bin/libpypy-c.so", mode: 0o755
    system "rsync -r --exclude='__pycache__' --exclude='*.c' --exclude '*.o' lib_pypy/ #{CREW_DEST_LIB_PREFIX}/pypy/lib_pypy/"
    system "rsync -r --exclude='__pycache__' --exclude='test' --exclude='tests' lib-python/ #{CREW_DEST_LIB_PREFIX}/pypy/lib-python/"
    system "rsync -r --include='*.h' -f 'hide,! */' include/ #{CREW_DEST_LIB_PREFIX}/pypy/include/"

    FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/bin/"
    FileUtils.symlink "../#{ARCH_LIB}/pypy/bin/pypy-c", "#{CREW_DEST_PREFIX}/bin/pypy2.7"
    FileUtils.symlink "pypy2", "#{CREW_DEST_PREFIX}/bin/pypy2"
    FileUtils.symlink "pypy/bin/libpypy-c.so", "#{CREW_DEST_LIB_PREFIX}/libpypy-c.so"
  end
end
