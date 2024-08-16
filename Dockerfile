FROM dolfinx/dolfinx:nightly

ARG NB_UID=9999
ARG NB_USER
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password --gecos "Main user" ${NB_USER}

WORKDIR ${HOME}
COPY . ${HOME}

# Update pip and install packages
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir \
    jupyterlab \
    scipy \
    matplotlib \
    pandas \
    pyvista \
    vedo \
    ipywidgets \
    ipygany

# Install JupyterLab extensions
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager \
                                 jupyter-threejs \
                                 @pyviz/jupyterlab_pyviz \
                                 @jupyterlab/geojson-extension

USER ${NB_USER}

# Specify a command to run when the container starts
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
