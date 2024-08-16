FROM dolfinx/dolfinx:nightly

ARG NB_UID=9999
ARG NB_USER
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password --gecos "Main user" ${NB_USER}

WORKDIR ${HOME}
COPY . ${HOME}

# Update pip and install packages without specifying versions
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir \
    jupyter \
    notebook \
    scipy \
    matplotlib \
    pandas \
    pyvista \
    vedo \
    pythreejs \
    jupyter_contrib_nbextensions \
    jupyter_nbextensions_configurator \
    ipygany

# Install notebook extensions
RUN jupyter contrib nbextension install --user
RUN jupyter nbextension enable --py --user pythreejs ipygany

USER ${NB_USER}

# Specify a command to run when the container starts
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
