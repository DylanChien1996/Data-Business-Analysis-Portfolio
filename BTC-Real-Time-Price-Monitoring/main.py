# main.py
from fastapi import FastAPI
from datetime import datetime
import time
import threading

from db import get_connection
from fetcher import fetch_btc_price

app = FastAPI()

def save_price(symbol: str, price: float):
    conn = get_connection()
    cursor = conn.cursor()
    sql = """
        INSERT INTO btc_price (symbol, price_usd, collected_at)
        VALUES (%s, %s, %s)
    """
    cursor.execute(sql, (symbol, price, datetime.now()))
    conn.commit()
    cursor.close()
    conn.close()

def price_scheduler(interval_seconds: int):
    while True:
        try:
            price = fetch_btc_price()
            save_price("BTC", price)
            print(f"[SAVED] BTC = {price}")
        except Exception as e:
            print("Error:", e)

        time.sleep(interval_seconds)

@app.on_event("startup")
def start_scheduler():
    thread = threading.Thread(
        target=price_scheduler,
        args=(60,),  # 300 s
        daemon=True
    )
    thread.start()

