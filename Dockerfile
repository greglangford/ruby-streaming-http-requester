FROM ruby:2.6.3

WORKDIR /app
COPY ./app /app

CMD ["ruby", "main.rb"]
