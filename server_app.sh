#!/bin/bash


# set -m

# /usr/sbin/sshd -D &
# jupyter lab --no-browser --port=8889 &

# fg %1


# Start the first process
/usr/sbin/sshd -D &

# python3 ./kohya_gui.py --inbrowser --headless --listen 0.0.0.0 --server_port 7860 &

# Start the second process
cd /opt/filebrowser/
./filebrowser  &

cd /ComfyUI
python -u main.py --listen --port 7860 &

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?