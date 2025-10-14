# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

def load_json
  File.open('memo.json') do |file|
    JSON.parse(file.read)
  end
end

def read_json
  JSON.parse(File.read('memo.json'))
end

def open_json(data)
  File.open('memo.json', 'w') do |f|
    JSON.dump(data, f)
  end
end

get '/memo/top' do
  @json_data = load_json['memos']
  erb :top
end

post '/memo/top' do
  title = params[:title]
  body = params[:content]

  existing_data = JSON.parse(File.read('memo.json'))
  existing_data['memos'].push({ 'id' => existing_data['memos'].size + 1, 'title' => title, 'body' => body })

  open_json(existing_data)

  redirect '/memo/top'
end

patch '/memo/top' do
  title = params[:title]
  body = params[:content]

  existing_data = JSON.parse(File.read('memo.json'))
  existing_data['memos'][params[:id].to_i - 1]['title'] = title
  existing_data['memos'][params[:id].to_i - 1]['body'] = body

  open_json(existing_data)

  redirect '/memo/top'
end

delete '/memo/top' do
  existing_data = JSON.parse(File.read('memo.json'))
  existing_data['memos'].delete_at(params[:id].to_i - 1)

  open_json(existing_data)

  redirect '/memo/top'
end

get '/memo/new' do
  erb :new
end

get '/memo/:id' do
  @json_data = load_json['memos']
  @id = params[:id].to_i - 1
  erb :show
end

get '/memo/:id/edit' do
  @json_data = load_json['memos']
  @id = params[:id].to_i - 1
  erb :edit
end
