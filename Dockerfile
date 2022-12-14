# specifies the base image

FROM python:3.10-slim-buster 

# sets a special python settings for being able to see logs
ENV PYTHONUNBUFFERED=TRUE

# installs pipenv
RUN pip --no-cache-dir install pipenv

# sets the working directory to /app
WORKDIR /app

# Copies the pipenv files
COPY ["Pipfile", "Pipfile.lock", "./"]

#installs the dependencies from the pipenv files
RUN pipenv install --deploy --system && \
    rm -rf /root/.cache 

# copies our code as well as the model
COPY ["*.py", "churn_model.bin", "./"]

# opens the port the our web services uses
EXPOSE 9696

# specifies how the service should be started
ENTRYPOINT [ "gunicorn", "--bind", "0.0.0.0:9696", "churn_serving:app" ]

