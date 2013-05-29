require 'formula'

class Pykep < Formula
  homepage 'http://keptoolbox.sourceforge.net/'
  url 'https://github.com/esa/pykep/archive/master.zip'
  sha1 '3b28a30ec9037347a3892f3cad38870abab825d8'
  version '1.1.3'

  env :std
  depends_on 'cmake' => :build
  depends_on 'boost' => :optional
  option 'build-boost' , 'This will build the boost libraries and link them against your python distribution.
        If you are using Apple or Homebrew python use --with-boost.'

  def install
    if build.include? 'build-boost'
      system "brew install boost --build-from-source --env=std"
    elsif build.with? 'boost'
      opoo "Building bottled boost as you asked..."
    else
      opoo "
Do you have boost installed?
Is it linked against the correct python?" 
    end

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
    system "echo 'import PyKEP' | python"
  end
end
