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
  JSON.parse(File.read('memo.json'))
end

def rewrite_json(data)
  File.open('memo.json', 'w') do |f|
    JSON.dump(data, f)
  end
end

get '/memos' do
  filename = 'memo.json'
  if !File.exist?(filename)
    File.open(filename, 'w') do |file|
      file.puts '{ "memos":{} }'
    end
    File.read(filename)
  end

  @json_memo_data = load_json['memos']
  @no_memo_coment = 'メモがありません'
  erb :top
end

post '/memos/new' do
  title = params[:title]
  body = params[:content]

  json_data = load_json
  json_data['memos'][SecureRandom.uuid] = { 'title' => title, 'body' => body }

  rewrite_json(json_data)

  redirect '/memos'
end

patch '/memos/:id' do
  title = params[:title]
  body = params[:content]
  @id = params[:id]

  json_data = load_json
  title_and_body = json_data['memos'][params[:id]]
  title_and_body['title'] = title
  title_and_body['body'] = body

  rewrite_json(json_data)

  redirect '/memos'
end

delete '/memos/:id' do
  @id = params[:id]

  json_data = load_json
  json_data['memos'].delete(params[:id])

  rewrite_json(json_data)

  redirect '/memos'
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  @json_memo_title = load_json['memos'][params[:id]]['title']
  @json_memo_body = load_json['memos'][params[:id]]['body']
  @id = params[:id]
  erb :show
end

get '/memos/:id/edit' do
  @json_memo_title = load_json['memos'][params[:id]]['title']
  @json_memo_body = load_json['memos'][params[:id]]['body']
  @id = params[:id]
  erb :edit
end
