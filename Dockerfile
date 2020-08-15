#FROM python:3.7
#FROM python:3.7-slim
FROM python:3.7-alpine

RUN apk --no-cache add --virtual .build-deps \
        build-base \
        libffi-dev \
        libressl-dev \
  && python -m pip install --no-cache-dir \
       robotframework \
       robotframework-sshlibrary \
       robotframework-jsonlibrary \
       robotframework-requests \
  && apk --no-cache del .build-deps

#RUN python -m pip install --no-cache-dir \
#  robotframework \
#  robotframework-sshlibrary \
#  robotframework-jsonlibrary \
#  robotframework-requests

CMD ["robot", "-d", "/testsuite", "/testsuite"]
