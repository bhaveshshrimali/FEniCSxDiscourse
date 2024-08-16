FROM dolfinx/dolfinx:nightly

ARG NB_UID=9999
ARG NB_USER
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password --gecos "Main user" ${NB_USER}

WORKDIR ${HOME}
COPY . ${HOME}

# Specify exact version numbers for packages
RUN pip3 install --no-cache-dir \
    jupyter-notebook==6.4.12 \
    scipy==1.10.1 \
    matplotlib==3.7.1 \
    pandas==2.0.1 \
    pyvista==0.38.5 \
    vedo==2023.4.4 \
    pythreejs==2.4.2 \
    jupyter_contrib_nbextensions==0.7.0 \
    jupyter_nbextensions_configurator==0.6.1 \
    ipygany==0.5.0

# Install notebook extensions
RUN jupyter contrib nbextension install --user
RUN jupyter nbextension enable --py --user pythreejs ipygany

USER ${NB_USER}

# Specify a command to run when the container starts
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
