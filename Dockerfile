FROM ubuntu:22.04

### Fix the issue with noniteractive timezone data
ENV TZ=Europe/Helsinki
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update --fix-missing

### Ubuntu core packages
RUN apt update && apt install -y --no-install-recommends \
    curl nano gpg-agent git build-essential

### Python environment
RUN apt install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt update && \
    apt install -y python3.8 python3.8-venv python3.8-dev

# use python3.8 as default python version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

# install pip for python3.8
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# Copy requirements.txt to the docker image
COPY requirements.txt /tmp/requirements.txt

# install python packages from requirements.txt
RUN pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

# copy the source code to the docker image
COPY src /app/src
# set the Python path to the src folder
ENV PYTHONPATH=/app/src
# run the application
EXPOSE 8000
WORKDIR /app
ENTRYPOINT ["uvicorn", "src.main:app", "--port", "8000", "--host", "0.0.0.0"]