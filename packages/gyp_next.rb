require 'package'

class Gyp_next < Package
  description 'GYP can Generate Your Projects.'
  homepage 'https://github.com/nodejs/gyp-next'
  version '0.8.0'
  license 'BSD'
  compatibility 'all'
  source_url 'SKIP'

  binary_url({
    aarch64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/gyp_next/0.8.0_armv7l/gyp_next-0.8.0-chromeos-armv7l.tar.xz',
     armv7l: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/gyp_next/0.8.0_armv7l/gyp_next-0.8.0-chromeos-armv7l.tar.xz',
       i686: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/gyp_next/0.8.0_i686/gyp_next-0.8.0-chromeos-i686.tar.xz',
     x86_64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/gyp_next/0.8.0_x86_64/gyp_next-0.8.0-chromeos-x86_64.tar.xz'
  })
  binary_sha256({
    aarch64: '6f9637bbb731df38ebe855839e40e7c390127fc391e37428acf9ab978e73607b',
     armv7l: '6f9637bbb731df38ebe855839e40e7c390127fc391e37428acf9ab978e73607b',
       i686: '9662dcd813ad9d11c600d92f00cadc549ea787533c228b34bcf1b28e5cb9d180',
     x86_64: '4e94350d25225bc3ccc8a2b32d710ccef16ea2ce637969774ccccc8b85d8edd9'
  })

  def self.install
    system 'pip3 uninstall -y gyp-next'
    system "pip3 install --upgrade --no-warn-script-location gyp-next --prefix #{CREW_PREFIX} --root #{CREW_DEST_DIR}"
  end
end
