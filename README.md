# RAG Server

## Requirements

* Python 3.8
* `pip install -r requirements.txt`

## Local Development

`. run.sh`

Go to web browser and open `http://localhost:8000/docs` to see the API documentation.

Example of a request body for `/api/rag`:

```json
{
  "text": "string",
  "metadata": {
    "additionalProp1": "string",
    "additionalProp2": "string",
    "additionalProp3": "string"
  }
}
```

Example of response

```json
[
  {
    "start": 1,
    "end": 4,
    "label": "unknown",
    "explain": "This is 0-th random explanation for document ID=0 with metadata=additionalProp1=string, additionalProp2=string, additionalProp3=string content=string",
    "ID": 0
  },
  {
    "start": 0,
    "end": 6,
    "label": "unknown",
    "explain": "This is 1-th random explanation for document ID=0 with metadata=additionalProp1=string, additionalProp2=string, additionalProp3=string content=string",
    "ID": 0
  }
]
```

## Deployment

`./deploy.sh`
