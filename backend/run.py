import os
import ssl
import requests
from urllib3.exceptions import InsecureRequestWarning

os.environ['CURL_CA_BUNDLE'] = ''
os.environ['REQUESTS_CA_BUNDLE'] = ''
ssl._create_default_https_context = ssl._create_unverified_context
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

_original_send = requests.adapters.HTTPAdapter.send
def _patched_send(self, request, **kwargs):
    kwargs['verify'] = False
    return _original_send(self, request, **kwargs)
requests.adapters.HTTPAdapter.send = _patched_send

from app import create_app, db

app = create_app()

with app.app_context():
    from app.models import user, patient, knowledge, plan
    db.create_all()
    from app.services.rag_service import init_vector_store
    init_vector_store(app)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
