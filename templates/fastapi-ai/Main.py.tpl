from fastapi import FastAPI

app = FastAPI(title="{{project_name}}")

@app.get("/")
def read_root():
    return {"message": "AI Engine running for {{project_name}}"}
