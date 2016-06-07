FROM gliderlabs/herokuish

ADD . /app
RUN echo \
    'https://github.com/groonga/heroku-buildpack-groonga\n\
    https://github.com/heroku/heroku-buildpack-ruby\n'\
    > /app/.buildpacks
RUN herokuish buildpack build
# XXX workaround to override env by docker-compose
RUN rm /app/.profile.d/00_config_vars.sh
