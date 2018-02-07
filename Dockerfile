FROM fedora:26
RUN \
    dnf update --assumeyes && \
        dnf \
            install \
            --assumeyes \
            git \
            make \
            python \
            tar \
            which \
            bzip2 \
            ncurses \
            gmp-devel \
            mpfr-devel \
            libmpc-devel \
            glibc-devel \
            flex \
            bison \
            glibc-static \
            zlib-devel \
            gcc \
            gcc-c++ \
            nodejs && \
            mkdir /opt/docker && \
            mkdir /opt/docker/c9sdk && \
            git -C /opt/docker/c9sdk init && \
            git -C /opt/docker/c9sdk remote add origin git://github.com/c9/core.git && \
            git -C /opt/docker/c9sdk pull origin master && \
            /opt/docker/c9sdk/scripts/install-sdk.sh && \
            sed -i "s#127.0.0.1#0.0.0.0#g" /opt/docker/c9sdk/configs/standalone.js && \
            sed -i "s#opts[.]projectName = basename.opts[.]workspaceDir.;#opts.projectName = process.env.PROJECT_NAME#" /opt/docker/c9sdk/plugins/c9.vfs.standalone/standalone.js && \
            adduser user && \
            mkdir /opt/docker/workspace && \
            chown user:user /opt/docker/workspace && \
            dnf install --assumeyes sudo bash-completion && \
            echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user && \
            chmod 0444 /etc/sudoers.d/user && \
            dnf update --assumeyes && \
            dnf clean all
USER user
WORKDIR /home/user
RUN \
    curl -L https://raw.githubusercontent.com/c9/install/master/install.sh | bash && \
        mkdir .ssh && \
        mkdir .ssh/config.d && \
        echo "Include ~/.ssh/config.d/*" > .ssh/config && \
        chmod 0600 .ssh/config
COPY entrypoint.sh /opt/docker/entrypoint.sh
ENTRYPOINT ["sh", "/opt/docker/entrypoint.sh"]
CMD []
ONBUILD USER root
ONBUILD COPY root /opt/docker/extension/
ONBUILD RUN \
    if [ -d /opt/docker/extension/sbin ]; then ls -1 /opt/docker/extension/sbin | while read FILE; do cp /opt/docker/extension/sbin/${FILE} /usr/local/sbin/${FILE%.*} && chmod 0500 /usr/local/sbin/${FILE%.*}; done; fi && \
        if [ -d /opt/docker/extension/bin ]; then ls -1 /opt/docker/extension/bin | while read FILE; do cp /opt/docker/extension/bin/${FILE} /usr/local/bin/${FILE%.*} && chmod 0555 /usr/local/bin/${FILE%.*}; done; fi && \
        if [ -f /opt/docker/extension/run.root.sh ]; then sh /opt/docker/extension/run.root.sh; fi && \
        if [ -d /opt/docker/extension/completion ]; then ls -1 /opt/docker/extension/completion | while read FILE; do cp /opt/docker/extension/completion/${FILE} /etc/bash_completion; done; fi
ONBUILD USER user
ONBUILD RUN \
    if [ -f /opt/docker/extension/run.user.sh ]; then sh /opt/docker/extension/run.user.sh; fi && \
        if [ -d /opt/docker/extension/ssh_config ]; then ls -1 /opt/docker/extension/ssh_config | while read FILE; do cp /opt/docker/extension/ssh_config/${FILE} /home/user/.ssh/config.d/${FILE} && chmod 0600 /home/user/.ssh/config.d/${FILE%}; done; fi
ONBUILD VOLUME /home/user
ONBUILD VOLUME /opt/docker/workspace

