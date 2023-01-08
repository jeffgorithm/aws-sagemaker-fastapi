from pydantic import BaseModel

class Request(BaseModel):
    url: str
