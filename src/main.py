import random
from typing import Dict, List, Literal, Union

from fastapi import FastAPI
from pydantic import BaseModel, Field

app = FastAPI()
random.seed(42)


class Document(BaseModel):
    content: str = Field(description="The content of the document or paragraph")
    metadata: Dict[str, str] = Field(description="Metadata of the document or paragraph, for example dict(title='My title', author='John Doe')")
    ID: int = Field(description="ID of the document or paragraph")


class Highlight(BaseModel):
    start: int = Field(description="Start index of the highlight")
    end: int = Field(description="End index of the highlight")
    label: Literal["mismatch", "match", "unknown"] = Field(description="Label of the highlight")
    explain: str = Field(description="Explanation of the highlight")
    ID: int = Field(description="ID of the document or paragraph")


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.post("/rag/")
def process_docs(docs: List[Document]) -> List[Highlight]:
    highlights = []
    for doc in docs:
        doc: Document
        meta = ', '.join([f"{k}={v}" for k, v in doc.metadata.items()])
        n_hightlights = random.randint(1, 5)

        for i in range(n_hightlights):
            start = random.randint(0, len(doc.content) // 2)
            end = random.randint(len(doc.content) // 2 + 1, len(doc.content))
            label = random.choice(["mismatch", "match", "unknown"])
            explain = f"This is {i}-th random explanation for document ID={doc.ID} with metadata={meta} content={doc.content[:10]}"
            highlights.append(Highlight(start=start, end=end, label=label, explain=explain, ID=doc.ID))

    return highlights
