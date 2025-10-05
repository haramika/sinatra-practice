# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/memo/top' do
  json_date = File.open('memo.json') do |file|
    JSON.parse(file.read)
  end
  json_dates = json_date['memos']

  @json_date = json_dates
  erb :top
end

post '/memo/top' do
  title = params[:title]
  body = params[:content]

  existing_date = JSON.parse(File.read('memo.json'))
  existing_date['memos'].push({ 'id' => existing_date['memos'].size + 1, 'title' => title, 'body' => body })

  File.open('memo.json', 'w') do |f|
    JSON.dump(existing_date, f)
  end

  redirect '/memo/top'
end

patch '/memo/top' do
  title = params[:title]
  body = params[:content]

  existing_date = JSON.parse(File.read('memo.json'))
  existing_date['memos'][params[:id].to_i - 1]['title'] = title
  existing_date['memos'][params[:id].to_i - 1]['body'] = body

  File.open('memo.json', 'w') do |f|
    JSON.dump(existing_date, f)
  end

  redirect '/memo/top'
end

delete '/memo/top' do
  existing_date = JSON.parse(File.read('memo.json'))
  existing_date['memos'].delete_at(params[:id].to_i - 1)

  File.open('memo.json', 'w') do |f|
    JSON.dump(existing_date, f)
  end

  redirect '/memo/top'
end

get '/memo/new' do
  erb :new
end

get '/memo/:id' do
  json_date = File.open('memo.json') do |file|
    JSON.parse(file.read)
  end
  json_dates = json_date['memos']

  @json_date = json_dates
  @id = params[:id].to_i - 1
  erb :show
end

get '/memo/:id/edit' do
  json_date = File.open('memo.json') do |file|
    JSON.parse(file.read)
  end
  json_dates = json_date['memos']

  @json_date = json_dates
  @id = params[:id].to_i - 1
  erb :edit
end
