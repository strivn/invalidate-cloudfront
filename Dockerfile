FROM python:3.12-alpine

LABEL version="0.0.1"
LABEL repository="https://github.com/strivn/invalidate-cloudfront"

# https://github.com/aws/aws-cli/blob/master/CHANGELOG.rst
ENV AWSCLI_VERSION='1.33.1'

RUN pip install --quiet --no-cache-dir awscli==${AWSCLI_VERSION}

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
