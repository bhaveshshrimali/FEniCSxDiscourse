FROM dolfinx/dolfinx:latest

# create user with a home directory
ARG NB_USER
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Copy home directory for usage in binder
WORKDIR ${HOME}
COPY . ${HOME}
RUN pip3 install --no-cache-dir jupyterhub notebook
RUN pip3 install --upgrade scipy matplotlib pandas
RUN pip3 install pyvista scikit-fem vedo
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
ENTRYPOINT []