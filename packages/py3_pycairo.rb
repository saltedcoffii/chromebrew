require 'package'

class Py3_pycairo < Package
  description 'Pycairo is a provides bindings for the cairo graphics library.'
  homepage 'https://cairographics.org/pycairo/'
  @_ver = '1.20.0'
  version @_ver
  license 'LGPL-2.1 or MPL-1.1'
  compatibility 'all'
  source_url 'https://github.com/pygobject/pycairo.git'
  git_hashtag 'v' + @_ver

  depends_on 'cairo'
  depends_on 'libxxf86vm'
  depends_on 'libxrender'
  depends_on 'py3_setuptools' => :build

  def self.build
    system "python3 setup.py build #{PY3_SETUP_BUILD_OPTIONS}"
  end

  def self.install
    system "python3 setup.py install #{PY_SETUP_INSTALL_OPTIONS}"
  end
end