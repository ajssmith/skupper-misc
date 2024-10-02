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

result=$(grep ServiceControllerImageName $file)
IFS=' ' read -r -a array <<< "$result"
servicecontroller=$(echo "${array[@]: -1:1}" | cut -c2- | rev | cut -c2- | rev)

result=$(grep ControllerPodmanImageName $file)
IFS=' ' read -r -a array <<< "$result"
controllerpodman=$(echo "${array[@]: -1:1}" | cut -c2- | rev | cut -c2- | rev)

result=$(grep ConfigSyncImageName $file)
IFS=' ' read -r -a array <<< "$result"
configsync=$(echo "${array[@]: -1:1}" | cut -c2- | rev | cut -c2- | rev)

result=$(grep FlowCollectorImageName $file)
IFS=' ' read -r -a array <<< "$result"
flowcollector=$(echo "${array[@]: -1:1}" | cut -c2- | rev | cut -c2- | rev)

result=$(grep SiteControllerImageName $file)
IFS=' ' read -r -a array <<< "$result"
sitecontroller=$(echo "${array[@]: -1:1}" | cut -c2- | rev | cut -c2- | rev)

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
printf "%s \n" $servicecontroller >> $save
printf "%s \n" $controllerpodman >> $save
printf "%s \n" $configsync >> $save
printf "%s \n" $flowcollector >> $save
printf "%s \n" $sitecontroller >> $save
printf "\n" >> $save
printf "%s \n" "From $promregistry" >> $save
printf "%s \n" $promserver >> $save
printf "\n" >> $save
printf "%s \n" "From $oauthregistry" >> $save
printf "%s \n" $oauthproxy >> $save

unset IFS
