#!/bin/bash

# use ps aux and grep to check if uvicorn is running
if ps aux | grep uvicorn | grep -v grep >/dev/null; then
    echo "Uvicorn is already running"
else
    echo "Uvicorn is not running, Starting uvicorn"
    export PYTHONPATH=src
    uvicorn src.main:app --reload --port 8000
fi

# test the api
curl -X 'POST' \
    'http://127.0.0.1:8000/rag/' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '[
  {
    "content": "It is with deep concern and a commitment to public safety that we bring this matter before the court. Tesla, a pioneer in the field of electric vehicles and autonomous driving technology, has marketed and sold vehicles equipped with the Autopilot feature, purportedly designed to enhance driver convenience and safety. However, our investigation and evidence will demonstrate that the Autopilot system falls short of these promises, placing drivers and passengers at an unacceptable risk of harm.",
    "metadata": {
      "author": "lawer",
      "title": "Tesla Law Suite",
      "case": "Autopilot cannot distinguish between a balloon and cloud."
    },
    "ID": 123
  }
]'
