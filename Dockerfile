# FROM dolfinx/dolfinx:nightly

# # create user with a home directory
# ARG NB_USER
# ARG NB_UID=2000
# ENV USER ${NB_USER}
# ENV HOME /home/${NB_USER}

# RUN adduser --disabled-password \
#     --gecos "Default user" \
#     --uid ${NB_UID} \
#     ${NB_USER}

# # Copy home directory for usage in binder
# WORKDIR ${HOME}
# COPY . ${HOME}
# RUN pip3 install --no-cache-dir jupyter notebook
# RUN pip3 install --upgrade scipy matplotlib pandas
# RUN pip3 install pyvista vedo pythreejs
# RUN pip3 install jupyter_contrib_nbextensions jupyter_nbextensions_configurator
# RUN jupyter contrib nbextension install --user
# RUN jupyter nbextension enable --py --sys-prefix pythreejs
# RUN pip3 install ipygany
# RUN jupyter nbextension enable --py --sys-prefix ipygany
# USER root
# RUN chown -R ${NB_UID} ${HOME}
# USER ${NB_USER}
# ENTRYPOINT []
FROM dolfinx/dolfinx:nightly

# Generate a random UID between 2000 and 9999 (adjust range as needed)
ARG NB_UID=$(shuf -i 2000-9999 -n 1)
ARG NB_USER
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password --gecos "Default user" --uid ${NB_UID} ${NB_USER}

WORKDIR ${HOME}
COPY . ${HOME}

# Use a package manager for system-level dependencies if needed
# RUN apt-get update && apt-get install -y ...

# Specify exact version numbers for packages
RUN pip3 install jupyter notebook scipy matplotlib pandas \
    pyvista vedo pythreejs jupyter_contrib_nbextensions jupyter_nbextensions_configurator ipygany

# Install notebook extensions
RUN jupyter contrib nbextension install
RUN jupyter nbextension enable --py --user pythreejs ipygany

# Set correct ownership if necessary
# RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}

# Specify a command to run when the container starts
ENTRYPOINT ["jupyter", "notebook", "--allow-root"]
