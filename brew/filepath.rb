require 'formula'

class Filepath < Formula
  homepage 'http://github.com/chendo/filepath'
  url 'https://github.com/downloads/chendo/filepath/filepath-0.3.tar.gz'
  md5 'c842a3bdaa8746d19bb10dface26a360'

  def install
    system "xcodebuild"
    bin.install 'build/Release/filepath'
  end

  def cavats; <<-EOS.undent
    To use filepath you must enable access for assistive devices in Universal Access.
    EOS
  end
end
