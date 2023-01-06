FROM redis:bullseye
COPY seeds.dat .
RUN  ["/bin/bash", "-c", " /usr/local/bin/redis-server --daemonize yes && while IFS= read -r line; do redis-cli $line; done < seeds.dat"]

