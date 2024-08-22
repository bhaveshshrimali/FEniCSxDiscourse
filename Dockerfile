FROM dolfinx/dolfinx:nightly

# # create user with a home directory
# ARG NB_USER=jovyan
# ARG NB_UID=1000
# RUN useradd -m ${NB_USER} -u ${NB_UID}
# ENV HOME /home/${NB_USER}

# # Update pip and install packages
# RUN pip3 install --no-cache-dir --upgrade pip && \
#     pip3 install --no-cache-dir \
#     jupyterlab \
#     jupyter \
#     notebook \
#     scipy \
#     matplotlib \
#     pandas \
#     pyvista[all] \
#     ipywidgets \
#     ipykernel

# RUN nb=$(which jupyter-notebook) \
#     && rm $nb \
#     && ln -s $(which jupyter-lab) $nb

# # Copy home directory for usage in binder
# WORKDIR ${HOME}
# COPY --chown=${NB_UID} . ${HOME}

# USER ${NB_USER}
# ENTRYPOINT []
# create user with a home directory
ARG NB_USER=jovyan
ARG NB_UID=1000
RUN useradd -m ${NB_USER} -u ${NB_UID}
ENV HOME /home/${NB_USER}

# for binder: base image upgrades lab to require jupyter-server 2,
# but binder explicitly launches jupyter-notebook
# force binder to launch jupyter-server instead
RUN nb=$(which jupyter-notebook) \
    && rm $nb \
    && ln -s $(which jupyter-lab) $nb

# Copy home directory for usage in binder
WORKDIR ${HOME}
COPY --chown=${NB_UID} . ${HOME}

USER ${NB_USER}
ENTRYPOINT []

# Specify a command to run when the container starts
# CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
