#!/usr/bin/env bash

version=$1
buildnum=$2
release=$version.GA
x86_linux_dir=./x86/skupper-cli-linux-on-x86-64-$version
x86_macosx_dir=./x86/skupper-cli-macosx-on-x86-64-$version
x86_windows_dir=./x86/skupper-cli-windows-on-x86-64-$version
x86_path=$release/redistributable/x86_64/usr/share/skupper-cli
aarch64_linux_dir=./aarch64/skupper-cli-linux-on-aarch64-$release
aarch64_path=$release/redistributable/aarch64/usr/share/skupper-cli
sources_dir=./skupper-sources-$release

mkdir -p $release/redistributable/x86_64
pushd $release/redistributable/x86_64
wget https://download.devel.redhat.com/brewroot/vol/rhel-9/packages/skupper-cli/$version/$buildnum.el9/x86_64/skupper-cli-redistributable-$version-$buildnum.el9.x86_64.rpm
rpm2archive skupper-cli-redistributable-$version-$buildnum.el9.x86_64.rpm
tar -xvf skupper-cli-redistributable-$version-$buildnum.el9.x86_64.rpm.tgz
rm skupper-cli-redistributable-$version-$buildnum.el9.x86_64.rpm
popd

mkdir -p $x86_linux_dir
mkdir -p $x86_macosx_dir
mkdir -p $x86_windows_dir

cp $x86_path/linux/skupper $x86_linux_dir
cp $x86_path/macosx/skupper $x86_macosx_dir
cp $x86_path/windows/skupper.exe $x86_windows_dir

pushd x86
tar -czvf skupper-cli-linux-on-x86-64-$release.tar.gz ./skupper-cli-linux-on-x86-64-$version
tar -czvf skupper-cli-macosx-on-x86-64-$release.tar.gz ./skupper-cli-macosx-on-x86-64-$version
zip skupper-cli-windows-on-x86-64-$release.zip ./skupper-cli-windows-on-x86-64-$version/skupper.exe
rm -rf ./skupper-cli-linux-on-x86-64-$version
rm -rf ./skupper-cli-macosx-on-x86-64-$version
rm -rf ./skupper-cli-windows-on-x86-64-$version
popd

mkdir -p $release/redistributable/aarch64
pushd $release/redistributable/aarch64
wget https://download.devel.redhat.com/brewroot/vol/rhel-9/packages/skupper-cli/$version/$buildnum.el9/aarch64/skupper-cli-redistributable-$version-$buildnum.el9.aarch64.rpm
rpm2archive skupper-cli-redistributable-$version-$buildnum.el9.aarch64.rpm
tar -xvf skupper-cli-redistributable-$version-$buildnum.el9.aarch64.rpm.tgz
rm skupper-cli-redistributable-$version-$buildnum.el9.aarch64.rpm
popd

mkdir -p $aarch64_linux_dir
cp $aarch64_path/linux/skupper $aarch64_linux_dir

pushd aarch64
tar -czvf skupper-cli-linux-on-aarch64-$release.tar.gz ./skupper-cli-linux-on-aarch64-$release
rm -rf ./skupper-cli-linux-on-aarch64-$release
popd

mkdir -p RHSI-$release
cp aarch64/* RHSI-$release
cp x86/* RHSI-$release


mkdir -p $sources_dir
pushd $sources_dir
wget https://download.devel.redhat.com/brewroot/vol/rhel-9/packages/skupper-cli/$version/$buildnum.el9/src/skupper-cli-$version-$buildnum.el9.src.rpm
rpmdev-extract skupper-cli-$version-$buildnum.el9.src.rpm
tar -czf skupper-cli-$version-$buildnum.el9.src.tar.gz skupper-cli-$version-$buildnum.el9.src
popd
./required-images.sh $sources_dir/skupper-cli-$version-$buildnum.el9.src/images.go RHSI-$release/skupper-cli-$version-required-images.txt


cp $sources_dir/skupper-cli-$version-$buildnum.el9.src.tar.gz RHSI-$release
cp $release/redistributable/x86_64/usr/share/licenses/skupper-cli-redistributable/LICENSE RHSI-$release/skupper-cli-$version-license.txt

rm -rf $sources_dir
rm -rf $release aarch64 x86
