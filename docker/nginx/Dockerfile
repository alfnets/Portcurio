FROM nginx:1.20.2

RUN rm -f /etc/nginx/conf.d/* && touch /etc/nginx/conf.d/default.conf
ADD nginx.conf.template /etc/nginx/templates/default.conf.template

CMD ["/bin/sh" , "-c" , "envsubst '$$R_PREFIX' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]