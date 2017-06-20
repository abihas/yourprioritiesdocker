FROM phusion/baseimage

RUN apt-get update && \
    apt-get install git npm postgresql-client -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /var/yourprio

RUN git clone https://github.com/rbjarnason/your-priorities-app.git /var/yourprio && \
    git submodule init && \
    git submodule update && \
    ln -s /usr/bin/nodejs /usr/bin/node && \
    npm install && \
    npm install -g bower
ADD bower.json /var/yourprio/
ADD config.json /var/yourprio/server_api/config/
ADD wait-for-it.sh /var/yourprio/
# RUN ls -a /var/yourprio/ && \
#     cat /var/yourprio/bower.json

RUN cd client_app && \
    bower install --allow-root --force-latest --config.interactive=false

ENV REDIS_URL redis://redis:6379
ENV POSTGRES_URL postgres://postgres:postgres@postgres:5432/postgres
RUN chmod +x /var/yourprio/wait-for-it.sh
#RUN ["/sbin/my_init"]
CMD ["/var/yourprio/wait-for-it.sh", "postgres:5432", "--", "./start"]

# WORKDIR /tmp/gems
# ADD Gemfile /tmp/gems/Gemfile
# RUN bundle install --path vendor/bundle

# WORKDIR /home/app
# ADD . /home/app
# RUN bundle exec rake asset:precompile

# RUN mv /tmp/gems/vendor/bundle vendor/bundle

# CMD bundle exec rails server
