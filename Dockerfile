FROM dolfinx/dolfinx:nightly

ARG NB_UID=9999
ARG NB_USER
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password --gecos "Main user" ${NB_USER}

WORKDIR ${HOME}
COPY . ${HOME}

# Install Node.js and npm
RUN apt-get update && apt-get install -y nodejs npm && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

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
    ipygany \
    pythreejs \
    pyviz_comms

# Install JupyterLab extensions using pip
RUN pip3 install --no-cache-dir \
    jupyterlab-pyviz \
    jupyterlab-geojson

# Enable extensions
RUN jupyter labextension enable @jupyter-widgets/jupyterlab-manager \
                               @pyviz/jupyterlab_pyviz \
                               @jupyterlab/geojson-extension
RUN jupyter labextension enable --py --sys-prefix pythreejs

USER ${NB_USER}

# Specify a command to run when the container starts
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
