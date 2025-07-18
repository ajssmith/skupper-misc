#!/usr/bin/env bash

if [[ -z "${1}" ]] || [[ -z "${2}" ]]; then
  echo ""
  echo "Please provide all the required parameters"
  echo " - [Required] Skupper version. Example : 1.9.2"
  echo " - [Required] Build Number.    Example : 1"
  echo " - [Optional] Skupper Branch.  Example : 1.9.2-fix"
  echo "   If a branch is not set, we use the version branch"
  echo ""
  echo "Full command : ./generate-download 1.9.2 1"
  exit 1
fi

version=$1
buildnum=$2
branch_default=$(echo "${version}" | awk -F "." '{print "rhsi-"$1"."$2"-rhel-9"}')
branch=${3:-${branch_default}}
release=$version.GA
x86_linux_dir=./x86/skupper-cli-linux-on-x86-64-$version
x86_macosx_dir=./x86/skupper-cli-macosx-on-x86-64-$version
x86_windows_dir=./x86/skupper-cli-windows-on-x86-64-$version
x86_path=$release/redistributable/x86_64/usr/share/skupper-cli
aarch64_linux_dir=./aarch64/skupper-cli-linux-on-aarch64-$release
aarch64_path=$release/redistributable/aarch64/usr/share/skupper-cli
s390x_linux_dir=./s390x/skupper-cli-linux-on-s390x-$release
s390x_path=$release/redistributable/s390x/usr/share/skupper-cli
sources_dir=./skupper-sources-$release
deployment_dir=./skupper-deployment-$release

echo ""
echo "==============================================="
echo "== STEP 01 - Generating Downloads            =="
echo "==============================================="

### x86_64
echo ""
echo "==  01.1 - Generating Downloads for x86_64"

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

### aarch64
echo ""
echo "==  01.2 - Generating Downloads for AARCH_64"

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

### s390x
echo ""
echo "==  01.3 - Generating Downloads for S390X"
mkdir -p $release/redistributable/s390x
pushd $release/redistributable/s390x
wget https://download.devel.redhat.com/brewroot/vol/rhel-9/packages/skupper-cli/$version/$buildnum.el9/s390x/skupper-cli-redistributable-$version-$buildnum.el9.s390x.rpm
rpm2archive skupper-cli-redistributable-$version-$buildnum.el9.s390x.rpm
tar -xvf skupper-cli-redistributable-$version-$buildnum.el9.s390x.rpm.tgz
rm skupper-cli-redistributable-$version-$buildnum.el9.s390x.rpm
popd

mkdir -p $s390x_linux_dir
cp $s390x_path/linux/skupper $s390x_linux_dir

pushd s390x
tar -czvf skupper-cli-linux-on-s390x-$release.tar.gz ./skupper-cli-linux-on-s390x-$release
rm -rf ./skupper-cli-linux-on-s390x-$release
popd

echo ""
echo "==============================================="
echo "== STEP 02 - Copy artifacts to RHSI-$release =="
echo "==============================================="
mkdir -p RHSI-$release
echo ""
echo "==  02.1 - Copying S390X"
cp s390x/* RHSI-$release
echo ""
echo "==  02.2 - Copying AARCH_64"
cp aarch64/* RHSI-$release
echo ""
echo "==  02.3 - Copying x86_64"
cp x86/* RHSI-$release


echo ""
echo "==============================================="
echo "== STEP 03 - Creating Sources                =="
echo "==============================================="
mkdir -p $sources_dir
pushd $sources_dir
wget https://download.devel.redhat.com/brewroot/vol/rhel-9/packages/skupper-cli/$version/$buildnum.el9/src/skupper-cli-$version-$buildnum.el9.src.rpm
rpmdev-extract skupper-cli-$version-$buildnum.el9.src.rpm
tar -czf skupper-cli-$version-$buildnum.el9.src.tar.gz skupper-cli-$version-$buildnum.el9.src
popd
./required-images.sh $sources_dir/skupper-cli-$version-$buildnum.el9.src/images.go RHSI-$release/skupper-cli-$version-required-images.txt
echo "==  Sources created"

#
# We only deliver deployments for Skupper v2
#
if [ "${version:0:1}" == "2" ]; then
  echo ""
  echo "==============================================="
  echo "== STEP 04 - Creating Deployments            =="
  echo "==============================================="
  mkdir -p $deployment_dir
  pushd $deployment_dir
  git clone https://pkgs.devel.redhat.com/git/containers/skupper-operator-bundle
  cd skupper-operator-bundle
  git checkout $branch
  cd deployment
  tar -czvf ../../skupper-deployments-$version.tar.gz ./
  cd ../../
  popd
  echo "==  Deployments created"
else
  echo ""
  echo "==  Skipping Deployment creation, not Skupper v2"
fi


echo ""
echo "==============================================="
echo "== STEP 05 - Sources,Deployments and licence =="
echo "========================================="
cp $sources_dir/skupper-cli-$version-$buildnum.el9.src.tar.gz RHSI-$release
cp $release/redistributable/x86_64/usr/share/licenses/skupper-cli-redistributable/LICENSE RHSI-$release/skupper-cli-$version-license.txt
if [ "${version:0:1}" == "2" ]; then
  cp $deployment_dir/skupper-deployments-$version.tar.gz RHSI-$release
fi
echo "==  All copies done"


echo ""
echo "==============================================="
echo "== STEP 06 - Cleanup                         =="
echo "==============================================="
rm -rf $sources_dir
rm -rf $release aarch64 x86 s390x
rm -rf $deployment_dir
