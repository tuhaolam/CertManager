FROM ubuntu:15.04

RUN /usr/bin/apt-get update && /usr/bin/apt-get install --no-install-recommends -qy ruby ruby-dev make g++ libsqlite3-dev libsqlite3-0 patch zlib1g-dev libghc-zlib-dev nodejs && gem install bundler --no-ri --no-rdoc
ADD Gemfile /rails-app/Gemfile
ADD Gemfile.lock /rails-app/Gemfile.lock
WORKDIR /rails-app
RUN /usr/bin/env bundle install
RUN /usr/bin/apt-get -qy purge ruby-dev g++ make patch && /usr/bin/apt-get -qy autoremove
ADD . /rails-app
RUN find public -mindepth 1 -not -name 'assets' -not -name 'manifest-*.json' -print -delete
RUN find . -type f -print -exec chmod 444 {} \; && find . -type d -print -exec chmod 555 {} \;
RUN chown www-data:www-data db && chown -R www-data:www-data tmp
RUN chmod 755 db && find tmp -type d -print -exec chmod 755 {} \;
RUN find bin -type f -print -exec chmod 544 {} \;
USER www-data
CMD unicorn -o 0.0.0.0 -p 3000 -c unicorn.rb
