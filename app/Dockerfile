FROM snykt/middleware

EXPOSE 8080

WORKDIR /app
ADD app.py .

CMD ["gunicorn", "-w", "4", "app:app"]
