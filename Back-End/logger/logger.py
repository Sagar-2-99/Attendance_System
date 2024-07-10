import datetime

def logInfo(api_reference : str, message : str, data : any):
    print(f"[*] INFO::{datetime.datetime.now()} => api reference : {api_reference} :: Message :: {message} Data ::: {data}")


def logError(api_refernce : str, message : str, data : any):
    print(f"")