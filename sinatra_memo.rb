# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'cgi'

helpers do
  def h(text)
    CGI.escapeHTML(text.to_s)
  end
end

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

  existing_data = read_json
  existing_data['memos'].push({ 'id' => SecureRandom.uuid, 'title' => title, 'body' => body })

  open_json(existing_data)

  redirect '/memo/top'
end

patch '/memo/:id/edit' do
  title = params[:title]
  body = params[:content]
  @id = params[:id]

  existing_data = read_json
  existing_data['memos'].each do |data|
    data['title'] = title if data.value?(params[:id])
    data['body'] = body if data.value?(params[:id])
  end

  open_json(existing_data)

  redirect '/memo/top'
end

delete '/memo/:id/delete' do
  @id = params[:id]

  existing_data = read_json
  existing_data['memos'].delete_if do |data|
    data.value?(params[:id])
  end

  open_json(existing_data)

  redirect '/memo/top'
end

get '/memo/new' do
  erb :new
end

get '/memo/:id' do
  @json_data = load_json['memos']
  @id = params[:id]
  erb :show
end

get '/memo/:id/edit' do
  @json_data = load_json['memos']
  @id = params[:id]
  erb :edit
end
