require 'formula'

class Pagmo < Formula
  homepage 'https://sourceforge.net/projects/pagmo/'
  url 'http://sourceforge.net/code-snapshots/git/p/pa/pagmo/code.git/pagmo-code-13f3db11b7be920f30b3be459c8bf7cfeffaa37e.zip'
  sha1 '5c21abfedac544392bcec4566e5018fba44515cb'

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
      system "cmake",  "../", "-DBUILD_PYGMO=ON", "-DPYTHON_LIBRARY:FILEPATH=#{ppath}/libpython2.7.dylib", "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      system "make"
      system "make" ,"install" # if this fails, try separate make/make install steps
      system "ln", "-sf" , "#{lib}/python2.7/site-packages/PyGMO", "#{ppath}/python2.7/site-packages/"
    end
  end

  test do
    system "echo 'import PyGMO' | python"
  end
end
