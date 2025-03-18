FROM python:3.10-slim

WORKDIR /2-app

COPY . .

RUN pip3 install -r requirements.txt

EXPOSE 8080

CMD ["python", "calculator.py"]