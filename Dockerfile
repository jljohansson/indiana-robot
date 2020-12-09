FROM python:3.6-alpine

RUN apk --no-cache add --virtual .build-deps \
      build-base \
      libffi-dev \
      openssl-dev \
 && python -m pip install --no-cache-dir \
       robotframework \
       robotframework-sshlibrary \
       robotframework-jsonlibrary \
       robotframework-requests \
 && apk --no-cache del .build-deps

CMD ["robot", "-d", "/testsuite", "/testsuite"]
