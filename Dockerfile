# Dockerfile autogenerated on 06/20/2022, 07:33:14 by root
# Please do not edit this file directly

FROM nvidia/cudagl:10.1-base-ubuntu18.04

LABEL Author="Or Fleisher <or.fleisher@nytimes.com>"
LABEL Title="Blender in Docker"

# Environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV PATH "$PATH:/bin/3.2/python/bin/"
ENV BLENDER_PATH "/bin/3.2"
ENV BLENDERPIP "/bin/3.2/python/bin/pip3"
ENV BLENDERPY "/bin/3.2/python/bin/python3.10"
ENV HW="GPU"

# Install dependencies
RUN apt-get update && apt-get install -y \
        vim \
	wget \ 
	libopenexr-dev \ 
	bzip2 \ 
	build-essential \ 
	zlib1g-dev \ 
	libxmu-dev \ 
	libxi-dev \ 
	libxxf86vm-dev \ 
	libfontconfig1 \ 
	libxrender1 \ 
	libgl1-mesa-glx \ 
	xz-utils

# Download and install Blender
RUN wget https://mirror.clarkson.edu/blender/release/Blender3.2/blender-3.2.0-linux-x64.tar.xz \
	&& tar -xvf blender-3.2.0-linux-x64.tar.xz --strip-components=1 -C /bin \
	&& rm -rf blender-3.2.0-linux-x64.tar.xz \
	&& rm -rf blender-3.2.0-linux-x64

# Download the Python source since it is not bundled with Blender
RUN wget https://www.python.org/ftp/python/3.10.5/Python-3.10.5.tgz \
	&& tar -xzf Python-3.10.5.tgz \
	&& cp -r Python-3.10.5/Include/* $BLENDER_PATH/python/include/python3.10/ \
	&& rm -rf Python-3.10.5.tgz \
	&& rm -rf Python-3.10.5

# Blender comes with a super outdated version of numpy (which is needed for matplotlib / opencv) so override it with a modern one
RUN rm -rf ${BLENDER_PATH}/python/lib/python3.10/site-packages/numpy

# Must first ensurepip to install Blender pip3 and then new numpy
RUN ${BLENDERPY} -m ensurepip && ${BLENDERPIP} install --upgrade pip && ${BLENDERPIP} install numpy

# Set the working directory
RUN mkdir /render_results/
WORKDIR /render
COPY . .
CMD ["sleep", "infinity"]
