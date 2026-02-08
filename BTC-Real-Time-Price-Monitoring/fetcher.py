# fetcher.py
import requests

def fetch_btc_price():
    url = "https://api.coingecko.com/api/v3/simple/price"
    params = {
        "ids": "bitcoin",
        "vs_currencies": "usd"
    }
    response = requests.get(url, params=params, timeout=10)
    data = response.json()
    return data["bitcoin"]["usd"]
