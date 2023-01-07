FROM swipl/swish
RUN ["/usr/bin/apt", "update", "-y"]
RUN ["/usr/bin/apt", "install", "-y", "locales", "neovim", "mc", "redis"]
RUN ["/bin/rm", "-rf", "/var/lib/apt/lists/*"]
RUN ["localedef", "-i", "ru_RU", "-c", "-f", "UTF-8", "-A", "/usr/share/locale/locale.alias", "ru_RU.UTF-8"]
ENV LANG ru_RU.utf8
ENV LANGUAGE ru_RU.utf8
ENV LC_ALL ru_RU.utf8
RUN /bin/bash -c 'echo "au BufNewFile,BufRead *.prolog setf prolog" >> /usr/share/nvim/runtime/filetype.vim'
RUN /bin/bash -c 'echo "au BufNewFile,BufRead *.pl setf prolog" >> /usr/share/nvim/runtime/filetype.vim'
WORKDIR /srv
RUN mkdir seeds
COPY *.redis seeds/
RUN mkdir util
COPY *.prolog util/
ENTRYPOINT ["/bin/bash", "-c", "cat seeds/*.redis | while read line; do redis-cli -h redis $line; done &>/dev/null && tail -f /dev/null"]

