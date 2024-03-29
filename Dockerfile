FROM nginx:1.17

RUN apt-get update
RUN apt-get install -y wget

RUN wget https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz
RUN tar -xvzf entrykit_0.4.0_Linux_x86_64.tgz
RUN rm entrykit_0.4.0_Linux_x86_64.tgz
RUN mv entrykit /usr/local/bin/
RUN entrykit --symlink

RUN rm /etc/nginx/conf.d/*
COPY nginx/nginx.conf.tmpl /etc/nginx/
COPY nginx/conf.d/ /etc/nginx/conf.d/

ENTRYPOINT [\
  "render", \
  "/etc/nginx/nginx.conf", \
  "--", \
  "render", \
  "/etc/nginx/conf.d/upstream.conf", \
  "--", \
  "render", \
  "/etc/nginx/conf.d/public.conf", \
  "--" \
  ]
CMD ["nginx", "-g", "daemon off;"]