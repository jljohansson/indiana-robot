FROM python:3.8

RUN python -m pip install robotframework robotframework-sshlibrary robotframework-jsonlibrary robotframework-requests

CMD ["robot", "-d", "/suite", "/suite"]


