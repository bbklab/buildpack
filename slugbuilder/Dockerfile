FROM flynn/cedarish

ADD ./builder/ /tmp/builder
ADD ./buildpacks /tmp/buildpacks
RUN chown -R nobody:nogroup /tmp/buildpacks

ENV BASE_URL=http://52.68.20.57/resources
RUN /tmp/buildpacks/heroku-buildpack-java/bin/dl

ENTRYPOINT ["/tmp/builder/build.sh"]
CMD []
