FROM fedora:27
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
            adduser user && \
            mkdir /home/user/c9sdk && \
            git -C /home/user/c9sdk init && \
            git -C /home/user/c9sdk remote add origin git://github.com/c9/core.git && \
            git -C /home/user/c9sdk pull origin master && \
            /home/user/c9sdk/scripts/install-sdk.sh && \
            sed -i "s#127.0.0.1#0.0.0.0#g" /home/user/c9sdk/configs/standalone.js && \
            sed -i "s#opts[.]projectName = basename.opts[.]workspaceDir.;#opts.projectName = process.env.PROJECT_NAME#" /home/user/c9sdk/plugins/c9.vfs.standalone/standalone.js && \
            mkdir /home/user/workspace && \
            chown user:user /home/user/workspace && \
            dnf install --assumeyes sudo bash-completion && \
            curl -L https://raw.githubusercontent.com/c9/install/master/install.sh | su -c "bash" user && \
            dnf update --assumeyes && \
            dnf clean all
COPY entrypoint.user.sh entrypoint.root.sh /home/user/scripts/
ENTRYPOINT ["sh", "/home/user/scripts/entrypoint.root.sh"]
CMD []
ONBUILD COPY extension /home/user/extension
ONBUILD RUN \
    if [ -d /home/user/extension/sbin ]; then ls -1 /home/user/extension/sbin | while read FILE; do cp /home/user/extension/sbin/${FILE} /usr/local/sbin/${FILE%.*} && chmod 0500 /usr/local/sbin/${FILE%.*}; done; fi && \
        if [ -d /home/user/extension/bin ]; then ls -1 /home/user/extension/bin | while read FILE; do cp /home/user/extension/bin/${FILE} /usr/local/bin/${FILE%.*} && chmod 0555 /usr/local/bin/${FILE%.*}; done; fi && \
        if [ -f /home/user/extension/run.root.sh ]; then sh /home/user/extension/run.root.sh; fi && \
        if [ -d /home/user/extension/completion ]; then ls -1 /home/user/extension/completion | while read FILE; do cp /home/user/extension/completion/${FILE} /etc/bash_completion; done; fi
ONBUILD USER user
ONBUILD RUN \
    if [ -f /home/user/extension/run.user.sh ]; then sh /home/user/extension/run.user.sh; fi
ONBUILD USER root

