# Use Arch Linux as the base image
FROM archlinux:latest

# Set environment variables
ENV TERM xterm
ENV USER_ID 1000
ENV GROUP_ID 1000

# Copy necessary configuration files
COPY ./pacman.conf /etc/pacman.conf
COPY ./sudoers /etc/sudoers
COPY ./entrypoint.sh /
COPY ./install.sh /home/whoami/
COPY ./setting-up-wordlists.sh /home/whoami/
COPY ./exploit_databases_init.sh /home/whoami/

# Set the working directory
WORKDIR /home/whoami

# Install base packages and tools
RUN pacman --sync --refresh --sysupgrade --noconfirm && \
    pacman --needed --noconfirm sudo curl git base-devel python python-pip ruby && \
    curl --silent --show-error --output ./strap.sh https://blackarch.org/strap.sh && \
    chmod 755 ./strap.sh && \
    ./strap.sh && \
    rm ./strap.sh && \
    find / -type f '(' -name '*.pacnew' -or -name '*.pacsave' ')' -delete 2> /dev/null && \
    chmod 440 /etc/sudoers && \
    groupadd --gid $GROUP_ID whoami && \
    useradd --uid $USER_ID --gid $GROUP_ID --groups wheel --create-home whoami

# Set permissions
RUN chmod +x /home/whoami/install.sh && ./home/whoami/install.sh && \
    chmod +x /home/whoami/setting-up-wordlists.sh && ./home/whoami/setting-up-wordlists.sh

# Switch to the created user
USER whoami

# Set the entrypoint and command
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["zsh", "-ic", "tmux"]