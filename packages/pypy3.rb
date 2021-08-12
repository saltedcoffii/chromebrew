require 'package'

class Pypy3 < Package
  description 'A compliant implementation of Python, running up to 4.2x faster than the reference implementation.'
  homepage 'https://www.pypy.org/'
  @_ver = '7.3.5'
  version @_ver
  license 'MIT'
  compatibility 'all'
  source_url 'https://salsa.debian.org/debian/pypy3.git'
  git_hashtag 'upstream/' + @_ver + '+dfsg'

  def self.build
    system "./pypy/goal/pypy3-c -c \"import lib2to3.pygram, lib2to3.patcomp; lib2to3.patcomp.PatternCompiler()\""

    Dir.chdir 'lib_pypy' do
      cffi_targets = ['blake2/_blake2', 'sha3/_sha3', 'ssl', 'audioop', 'syslog', 'pwdgrp', 'resource', 'lzma', 'decimal', 'gdbm', 'curses', 'sqlite3']
      cffi_targets.each { |i|
        system "../pypy/goal/pypy3-c \"_#{i}_build.py\""
      }
    end
  end

  def self.install

  end
end
