bash vms/prepare.sh
bash vms/Python/build.sh

cmake -B build
cmake --build build
bash run.sh