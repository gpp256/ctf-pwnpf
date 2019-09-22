#!/bin/sh
#
# docker.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
cd `dirname $0`
. ./docker.conf

# Sub-Routines
# check docker status
status() {
  echo -- docker ps -a -f name="$VM_NAME" --
  docker ps -a -f name="$VM_NAME"
  echo -- docker images --
  docker images | grep $IMAGE_NAME
}

# build pwnpf-image
build() {
  docker build --network="host" -t ${IMAGE_NAME}:${TAG} ./
  docker images | grep $IMAGE_NAME
}

# start pwnpf-container
run() {
  mkdir -p $CTF_DATA_DIR
  docker run -itd --name $VM_NAME --entrypoint "/bin/bash" \
    --ulimit core=-1 --cap-add sys_ptrace \
    -v ${CTF_DATA_DIR}:/opt/ctf/data \
    --security-opt seccomp:unconfined ${IMAGE_NAME}:$TAG 
  docker ps -a -f name="$VM_NAME"
  docker inspect \
    --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $VM_NAME
}

# update pwnpf-container
update() {
  if docker ps --filter name=$VM_NAME | grep -q $VM_NAME ; then
    docker exec -it $VM_NAME bash -x /root/work/installer/binaries/update.sh
  else
    echo "Error: Failed to update $VM_NAME.: $VM_NAME is not running."
    exit 64
  fi
}

# create images
create_image() {
  docker stop $VM_NAME
  docker commit $VM_NAME ${IMAGE_NAME}:$TAG
  mkdir -p images
  [ -f images/${IMAGE_NAME}-${TAG}.tar.gz ] &&
    rm -f images/${IMAGE_NAME}-${TAG}.tar.gz
  docker save ${IMAGE_NAME}:$TAG > images/${IMAGE_NAME}-${TAG}.tar
  gzip images/${IMAGE_NAME}-${TAG}.tar
}

# test images
test_image() {
  if docker ps --filter name=$VM_NAME | grep -q $VM_NAME ; then
    docker exec -it $VM_NAME bash -x /root/work/installer/binaries/test.sh
  else
    echo "Error: Failed to check $VM_NAME.: $VM_NAME is not running."
    exit 65
  fi
}

# remove docker containers and docker images 
clean() {
  docker stop $VM_NAME 2>/dev/null
  docker rm $VM_NAME 2>/dev/null
  docker rmi $IMAGE_NAME:$TAG 2>/dev/null
  status
}

# Main Routine
case "$1" in 
  build) build ;;
  run) run ;;
  clean) clean ;;
  status) status ;;
  update) update ;;
  create_image) create_image ;;
  test_image) test_image ;;
  *) echo "Usage: $0 {build|run|clean|status|update|create_image|test_image}"; exit 1
esac
exit 0
#__END__
