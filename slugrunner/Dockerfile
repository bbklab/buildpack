FROM flynn/cedarish

USER root
WORKDIR /app
ADD ./runner/ /runner

ENTRYPOINT ["/runner/init"]
