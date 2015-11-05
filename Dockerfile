FROM python:2
RUN apt-get update \
    && apt-get install -y gfortran \
    && apt-get clean \
    && rm -fr /var/lib/apt/lists/*
RUN cd /tmp \
    && git clone -b master --depth 1 https://github.com/xianyi/OpenBLAS \
    && cd OpenBLAS \
    && make FC=gfortran \
    && make PREFIX=/opt/openblas install \
    && cd .. \
    && rm -fr OpenBLAS
COPY openblas.conf /etc/ld.so.conf.d/
RUN ldconfig
RUN pip install cython
RUN cd /tmp \
    && git clone -b v1.10.1 --depth 1 https://github.com/numpy/numpy
COPY site.cfg /tmp/numpy/
RUN cd /tmp/numpy \
    && python setup.py build --fcompiler=gnu95 \
    && python setup.py install \
    && cd .. \
    && rm -fr numpy
RUN pip install scipy

