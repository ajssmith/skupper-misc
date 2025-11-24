#!/usr/bin/env bash

#file="skupper-sources-1.5.5.GA/skupper-cli-1.5.5-1.el9.src/images.go"
file=$1
save=$2

result=$(grep DefaultImageRegistry $file)
IFS=' ' read -r -a array <<< "$result"
rhsiregistry=$(echo "${array[@]: -1:1}" | cut -c2- | rev | cut -c2- | rev)
rhsiregistry+=":"

result=$(grep RouterImageName $file)
IFS=' ' read -r -a array <<< "$result"
router=$(echo "${array[@]: -1:1}" | cut -c2- | rev | cut -c2- | rev)

result=$(grep ControllerImageName $file)
IFS=' ' read -r -a array <<< "$result"
controller=$(echo "${array[@]: -1:1}" | cut -c2- | rev | cut -c2- | rev)

result=$(grep KubeAdaptorImageName $file)
IFS=' ' read -r -a array <<< "$result"
kubeadaptor=$(echo "${array[@]: -1:1}" | cut -c2- | rev | cut -c2- | rev)

result=$(grep NetworkObserverImageName $file)
IFS=' ' read -r -a array <<< "$result"
networkobserver=$(echo "${array[@]: -1:1}" | cut -c2- | rev | cut -c2- | rev)

result=$(grep CliImageName $file)
IFS=' ' read -r -a array <<< "$result"
skuppercli=$(echo "${array[@]: -1:1}" | cut -c2- | rev | cut -c2- | rev)

result=$(grep SystemControllerImageName $file)
IFS=' ' read -r -a array <<< "$result"
systemcontroller=$(echo "${array[@]: -1:1}" | cut -c2- | rev | cut -c2- | rev)

result=$(grep PrometheusImageRegistry $file)
IFS=' ' read -r -a array <<< "$result"
promregistry=$(echo "${array[@]: -1:1}" | cut -c2- | rev | cut -c2- | rev)
promregistry+=":"

result=$(grep PrometheusServerImageName $file)
IFS=' ' read -r -a array <<< "$result"
promserver=$(echo "${array[@]: -1:1}" | cut -c2- | rev | cut -c2- | rev)

result=$(grep OauthProxyImageRegistry $file)
IFS=' ' read -r -a array <<< "$result"
oauthregistry=$(echo "${array[@]: -1:1}" | cut -c2- | rev | cut -c2- | rev)
oauthregistry+=":"

result=$(grep OauthProxyImageName $file)
IFS=' ' read -r -a array <<< "$result"
oauthproxy=$(echo "${array[@]: -1:1}" | cut -c2- | rev | cut -c2- | rev)

printf "%s \n" "From $rhsiregistry" > $save
printf "%s \n" $router >> $save
printf "%s \n" $controller >> $save
printf "%s \n" $kubeadaptor >> $save
printf "%s \n" $networkobserver >> $save
printf "%s \n" $skuppercli >> $save
printf "%s \n" $systemcontroller >> $save
printf "\n" >> $save
printf "%s \n" "From $promregistry" >> $save
printf "%s \n" $promserver >> $save
printf "\n" >> $save
printf "%s \n" "From $oauthregistry" >> $save
printf "%s \n" $oauthproxy >> $save

unset IFS
=====
