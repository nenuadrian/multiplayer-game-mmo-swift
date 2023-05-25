sudo apt update

sudo apt -y install clang libpython2.7 libpython2.7-dev

wget https://swift.org/builds/swift-5.7-release/ubuntu2004/swift-5.7-RELEASE/swift-5.7-RELEASE-ubuntu20.04.tar.gz

tar xzf swift-5.7-RELEASE-ubuntu20.04.tar.gz

rm swift-5.7-RELEASE-ubuntu20.04.tar.gz

sudo mv swift-5.7-RELEASE-ubuntu20.04 /usr/share/swift

echo "export PATH=/usr/share/swift/usr/bin:$PATH" >> ~/.zshrc

zsh

source ~/.zshrc

