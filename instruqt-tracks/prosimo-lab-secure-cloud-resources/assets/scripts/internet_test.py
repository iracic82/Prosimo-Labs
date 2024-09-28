import requests

# List of FQDNs to test egress traffic filtering
fqdn_list = [
    "http://www.google.com",
    "http://www.facebook.com",
    "http://www.bbc.com",
    "http://www.cloudflare.com",
]


def test_fqdn_access(fqdn):
    try:
        # Send a GET request to the FQDN
        response = requests.get(fqdn, timeout=10, allow_redirects=True)

        # Check for successful HTTP response status codes (200, 301, 302)
        if response.status_code in [200, 301, 302]:
            print(f"✅ Access allowed: {fqdn} (Status: {response.status_code})")
        else:
            print(f"❌ Access blocked or unexpected status: {fqdn} (Status: {response.status_code})")

    except requests.ConnectionError:
        print(f"❌ Connection Error: Could not reach {fqdn}")
    except requests.Timeout:
        print(f"❌ Timeout: {fqdn} took too long to respond")
    except requests.RequestException as e:
        print(f"❌ Error accessing {fqdn}: {e}")


if __name__ == "__main__":
    for fqdn in fqdn_list:
        print(f"Testing access to {fqdn} ...")
        test_fqdn_access(fqdn)