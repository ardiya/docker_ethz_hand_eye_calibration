#!/bin/bash
set -e

source "/opt/ros/$ROS_DISTRO/setup.bash"
. /catkin_ws/devel/setup.bash

exec "$@"
