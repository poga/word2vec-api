# The Google App Engine python runtime is Debian Jessie with Python installed
# and various os-level packages to allow installation of popular Python
# libraries. The source is on github at:
#   https://github.com/GoogleCloudPlatform/python-docker
FROM gcr.io/google_appengine/python

# Create a virtualenv for the application dependencies.
# If you want to use Python 2, add the -p python2.7 flag.
RUN virtualenv -p python3.4 /env

# Set virtualenv environment variables. This is equivalent to running
# source /env/bin/activate. This ensures the application is executed within
# the context of the virtualenv and will have access to its dependencies.
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

# Install dependencies.
ADD requirements.txt /app/requirements.txt
RUN pip2 install -r /app/requirements.txt

# Add application code.
ADD . /app

# Instead of using gunicorn directly, we'll use Honcho. Honcho is a python port
# of the Foreman process manager. $PROCESSES is set in the pod manifest
# to control which processes Honcho will start.
WORKDIR /app
CMD python2 word2vec-api.py --model ./GoogleNews-vectors-negative300-SLIM.bin --binary BINARY --path /word2vec --host 0.0.0.0 --port 5000

