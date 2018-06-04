FROM nginx
RUN apt-get update 
RUN apt-get -y install apache2-utils && htpasswd -cb /etc/nginx/.secrets_kibana admin pass
COPY nginx.conf /etc/nginx/nginx.conf
