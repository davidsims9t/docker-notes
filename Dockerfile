FROM python:3.6
RUN pip install Flask redis
RUN useradd -ms /bin/bash admin
USER admin
COPY app /app
WORKDIR /app
CMD ["python", "app.py"]
