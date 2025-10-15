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

def rewrite_json(data)
  File.open('memo.json', 'w') do |f|
    JSON.dump(data, f)
  end
end

get '/memos' do
  @json_data = load_json['memos']
  erb :top
end

post '/memos/new' do
  title = params[:title]
  body = params[:content]

  existing_data = read_json
  existing_data['memos'][SecureRandom.uuid] = { 'title' => title, 'body' => body }

  rewrite_json(existing_data)

  redirect '/memos'
end

patch '/memos/:id' do
  title = params[:title]
  body = params[:content]
  @id = params[:id]

  existing_data = read_json
  existing_data['memos'][params[:id]]['title'] = title
  existing_data['memos'][params[:id]]['body'] = body

  rewrite_json(existing_data)

  redirect '/memos'
end

delete '/memos/:id' do
  @id = params[:id]

  existing_data = read_json
  existing_data['memos'].delete(params[:id])

  rewrite_json(existing_data)

  redirect '/memos'
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  @json_data = load_json['memos']
  @id = params[:id]
  erb :show
end

get '/memos/:id/edit' do
  @json_data = load_json['memos']
  @id = params[:id]
  erb :edit
end
