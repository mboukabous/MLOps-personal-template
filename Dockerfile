FROM public.ecr.aws/lambda/python:3.10

RUN mkdir -p /app
COPY ./requirements.txt /app/
COPY ./main.py /app/
COPY ./myLib /app/myLib
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt
WORKDIR /app
EXPOSE 8080
CMD [ "main.py" ]
ENTRYPOINT [ "python" ]
