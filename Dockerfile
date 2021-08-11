FROM ros:melodic-perception-bionic
WORKDIR /

ADD package.list /tmp/package.list
RUN apt update>/dev/null && \
	apt install -y $(cat /tmp/package.list)>/dev/null && \
	rm -rf /var/lib/apt/lists/*

ADD deps.rosinstall /tmp/deps.rosinstall
ADD oomact /catkin_ws/src/oomact
RUN \
    mkdir -p /catkin_ws/src && \
    cd /catkin_ws && \
    catkin init && \
	catkin config --extend /opt/ros/melodic && \
    vcs import --recursive --input /tmp/deps.rosinstall src && \
	catkin build --cmake-args -DUSE_SYSTEM_EIGEN=ON -DCMAKE_CXX_FLAGS="-msse3 -msse4.1" -- \
	    hand_eye_calibration hand_eye_calibration_target_extractor hand_eye_calibration_batch_estimation oomact oomact_ros && \
	rm /tmp/deps.rosinstall /tmp/package.list

ADD ethz_entrypoint.sh /ethz_entrypoint.sh
ENTRYPOINT [ "/bin/bash", "/ethz_entrypoint.sh" ]
CMD ["bash"]
