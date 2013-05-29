require 'formula'

class Pykep < Formula
  homepage 'http://keptoolbox.sourceforge.net/'
  url 'https://github.com/esa/pykep/archive/master.zip'
  sha1 '3b28a30ec9037347a3892f3cad38870abab825d8'
  version '1.1.3'

  env :std
  depends_on 'cmake' => :build
  depends_on 'boost' => :optional
  option 'with-boost' , 'For compatibility with python distributions, boost dependency is optional.
If you are using Apple or home-brewed python, and boost is not installed use:
brew install pykep --with-boost

If you are using other python distribution (for instance, pythonbrew) then you need to be sure that
boost was built from the source and linked against that python. To build it use:
brew install boost --build-from-source --env=std
'

  def install
    Dir.mkdir "build"
    Dir.chdir "build" do
      ppath = ENV['PYTHONPATH']
      system "cmake",  "../", "-DBUILD_PYKEP=ON", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "-DPYTHON_LIBRARY:FILEPATH=#{ppath}/libpython2.7.dylib"
      system "make"
      system "make" ,"install" # if this fails, try separate make/make install steps
      system "ln", "-sf" , "#{lib}/python2.7/site-packages/PyKEP", "#{ppath}/python2.7/site-packages/"
    end
  end

  test do
    brew test pykep
  end
end
