FROM dolfinx/lab:latest

# create user with a home directory
ARG NB_USER
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

# Copy home directory for usage in binder
WORKDIR ${HOME}
COPY . ${HOME}
RUN pip3 install --no-cache-dir jupyterhub notebook
RUN pip3 install --upgrade numpy scipy matplotlib pandas
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
ENTRYPOINT []