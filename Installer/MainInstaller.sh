DIR=`pwd`

finish() {
	echo "Cleaning up..."
	rm $DIR/SDL2-2.0.3.tar.gz || true
	rm $DIR/SDL2_ttf-2.0.12.tar.gz || true
	rm $DIR/SDL2_image-2.0.0.tar.gz || true
	rm $DIR/SDL2_mixer-2.0.0.tar.gz || true
	rm -rf $DIR/SDL2_image-2.0.0  || true
	rm -rf $DIR/SDL2_ttf-2.0.12  || true
	rm -rf $DIR/SDL2-2.0.3 || true
	rm -rf $DIR/SDL2_mixer-2.0.0 || true
	rm -rf $DIR/wiringPi/ || true
	rm -rf $DIR/libmpg123/ || true
}

trap finish EXIT

USER=`whoami`
if [ $USER = "root" ]
    then
    echo "Running as ROOT"
else
    echo "***********YOU ARE NOT ROOT************"
    exit 0
fi

apt-get update --yes
apt-get install build-essential --yes

git clone https://github.com/gypified/libmpg123.git
cd libmpg123
./configure
make
sudo make install
cd ..

apt-get install libcv-dev --yes
apt-get install libopencv-dev --yes
apt-get install libao-dev --yes
apt-get install libasound2-dev --yes
apt-get install libpulse-dev --yes

apt-get install libdbus-1-dev --yes
apt-get install libudev-dev --yes

#SDL2.0
wget https://www.libsdl.org/release/SDL2-2.0.3.tar.gz
tar -xzvf SDL2-2.0.3.tar.gz
cd SDL2-2.0.3
ARCHITECTURE=`uname -m`
if [ ${ARCHITECTURE} = "armv7l"]
then
	echo "Downloading and installing all dependencies for the Raspberry Pi running Raspbian (Debian)"
    ./configure --host=armv71-raspberry-linux-gnueabihf --target=arm-raspberry-linux-gnueabihf --disable-video-opengl --disable-video-x11
else
	echo "Downloading and installing all dependencies for general Linux"
    ./configure 
fi

make -j4
make install -j4
cd ..

#SDL2_ttf
wget https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.12.tar.gz
tar -xzvf SDL2_ttf-2.0.12.tar.gz
cd SDL2_ttf-2.0.12
./configure
make -j4
make install -j4
cd ..

#SDL2_image
wget https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.0.tar.gz
tar -xzvf SDL2_image-2.0.0.tar.gz
cd SDL2_image-2.0.0
./configure
make -j4
make install -j4
cd ..
#SDL2_mixer
wget https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.0.tar.gz
tar -xzvf SDL2_mixer-2.0.0.tar.gz
cd SDL2_mixer-2.0.0
#SMPEG
cd external/smpeg2-2.0.0
./configure
make -j4
make install -j4
cd ../..
./configure
make -j4
make install -j4
cd ..

#install wiringPi
git clone git://git.drogon.net/wiringPi
cd wiringPi
git pull origin
./build
