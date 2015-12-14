require 'sinatra'
require 'sinatra/json'
require 'bundler'
Bundler.require
require 'review'


DataMapper.setup(:default, 'sqlite::memory:')
DataMapper.finalize
DataMapper.auto_migrate!

get '/' do
  "hello world"
end

get '/reviews' do
  content_type :json

  reviews = Review.all
  reviews.to_json
end

get '/reviews/:id' do
  content_type :json
  review = Review.get params[:id]
  review.to_json
end

post '/reviews' do
  content_type :json
  review = Review.new params[:review]
  if review.save
    status 201
  else
    status 500
    json review.errors.full_messages
  end
end

put '/reviews/:id' do
  content_type :json
  review = Review.get params[:id]
  if review.update params[:review]
    status 200
    json "Review was updated."
  else
    status 500
    json review.errors.full_messages
  end
end

delete '/reviews/:id' do
  content_type :json
  review = Review.get params[:id]
  if review.destroy
    status 200
    json "Review was deleted."
  else
    status 500
    json "There was a problem deleting the review."
  end
end

