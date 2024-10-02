import os
import requests
import json
from datetime import datetime

class CertUploader:
    def __init__(self, api_token):
        """
        Initialize the CertUploader class.

        Parameters:
        - api_token (str): The API token for authentication.
        """
        self.headers = {
            "Prosimo-ApiToken": api_token,  # Use the API token for authentication
            "accept": "application/json"
        }
        self.session = requests.Session()
        self.session.headers.update(self.headers)

    def upload_cert_and_key(self, base_url, certificate_path, private_key_path):
        """
        Upload the certificate and private key via HTTP POST request.

        Parameters:
        - base_url (str): The base URL for the API.
        - certificate_path (str): The path to the certificate file.
        - private_key_path (str): The path to the private key file.

        Returns:
        - dict: Response data from the API.
        """
        request_url = base_url + "cert/domain"

        # Check if the certificate and private key files exist
        if not os.path.exists(certificate_path):
            return {
                'status': 'failure',
                'error': f"Certificate file {certificate_path} not found."
            }

        if not os.path.exists(private_key_path):
            return {
                'status': 'failure',
                'error': f"Private key file {private_key_path} not found."
            }

        # Prepare the files for the POST request
        files = {
            'certificate': ('wildcard_with_san.crt', open(certificate_path, 'rb'), 'application/x-x509-ca-cert'),
            'privateKey': ('private.key', open(private_key_path, 'rb'), 'application/x-iwork-keynote-sffkey')
        }

        # Send the POST request to upload the certificate and private key
        response = self.session.post(request_url, files=files)

        # Handle the response
        if response.status_code == 200:
            return {
                'status': 'success',
                'data': response.json()
            }
        else:
            return {
                'status': 'failure',
                'error': f"HTTP {response.status_code}: {response.reason}",
                'details': response.json()
            }

# Function to write log messages to a log file
def write_log(log_file_path, message):
    with open(log_file_path, "a") as log_file:
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_file.write(f"[{timestamp}] {message}\n")

if __name__ == "__main__":
    # Fetch the API token and tenant ID from environment variables
    api_token = os.environ.get('TF_VAR_prosimo_token')
    tenant = os.environ.get('INSTRUQT_PARTICIPANT_ID')

    # Validate that required environment variables are set
    if not api_token:
        print("Error: API token not found in environment variable TF_VAR_prosimo_token.")
        exit(1)
    if not tenant:
        print("Error: Tenant name not found in environment variable INSTRUQT_PARTICIPANT_ID.")
        exit(1)

    # Define paths to the certificate, private key, and log file
    certificate_path = "/root/prosimo-lab/wildcard_with_san.crt"
    private_key_path = "/root/prosimo-lab/private.key"
    log_file_path = "/root/prosimo-lab/upload_log.txt"

    # Construct the base URL using the tenant name
    base_url = f"https://{tenant}.admin.prosimo.io/api/"

    # Initialize the CertUploader class
    cert_uploader = CertUploader(api_token)

    # Upload the certificate and private key
    response = cert_uploader.upload_cert_and_key(base_url, certificate_path, private_key_path)

    # Log the response and print it
    write_log(log_file_path, json.dumps(response, indent=4))
    print(json.dumps(response, indent=4))