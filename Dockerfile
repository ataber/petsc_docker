FROM ataber/cmake

RUN apt-get update --fix-missing \
&&  apt-get upgrade -y --force-yes \
&&  apt-get install -y --force-yes \
    bzip2 \
    gfortran \
    libblas-dev \
    liblapack-dev \
    unzip \
    wget \
    libopenmpi-dev \
    openmpi-bin \
&&  apt-get clean \
&&  rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Make open mpi use clang
ENV OMPI_CC clang-5.0
ENV OMPI_CXX clang++-5.0
ENV CC mpicc
ENV CXX mpicxx
ENV FC mpif90
ENV FF mpif77

#petsc
ENV PETSC_VERSION 3.9.3
ENV PETSC_DIR /usr/lib/petsc-lite-$PETSC_VERSION
ENV PETSC_ARCH linux-gnu
RUN cd /tmp && \
    wget http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-$PETSC_VERSION.tar.gz && \
    tar xf petsc-lite-$PETSC_VERSION.tar.gz && rm -f petsc-lite-$PETSC_VERSION.tar.gz && \
    cd petsc-lite-$PETSC_VERSION && \
    ./configure \
	--download-fblaslapack \
	--download-hypre=1  \
	--download-scalapack \
	--download-mumps \
	--download-metis \
	--download-parmetis \
	--download-superlu \
	--download-superlu_dist \
	--prefix=$PETSC_DIR \
	--with-clanguage=C++ \
	--with-debugging=1 \
    	--with-shared-libraries=1 \
	--with-x=0 \
    	COPTFLAGS='-O3' FOPTFLAGS='-O3' && \
    make PETSC_DIR=$PETSC_DIR PETSC_ARCH=$PETSC_ARCH && \
    cd /tmp && rm -rf petsc-$PETSC_VERSION

ENV METIS_DIR $PETSC_DIR
ENV SCALAPACK_DIR $PETSC_DIR
ENV PARMETIS_DIR $PETSC_DIR
ENV SUPERLU_DIR $PETSC_DIR
ENV SUPERLU_DIST_DIR $PETSC_DIR
ENV MUMPS_DIR $PETSC_DIR
