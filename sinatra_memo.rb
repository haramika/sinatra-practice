# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'cgi'

MEMOS_FILE = 'memos.json'

helpers do
  def h(text)
    CGI.escapeHTML(text.to_s)
  end
end

def load_memos
  JSON.parse(File.read(MEMOS_FILE))
end

def save_memos(data)
  File.open(MEMOS_FILE, 'w') do |f|
    JSON.dump(data, f)
  end
end

get '/memos' do
  save_memos({}) if !File.exist?(MEMOS_FILE)

  @memos = load_memos
  @id = params[:id]
  erb :top
end

post '/memos/new' do
  title = params[:title]
  body = params[:content]

  memos = load_memos
  memos[SecureRandom.uuid] = { 'title' => title, 'body' => body }

  save_memos(memos)

  redirect '/memos'
end

patch '/memos/:id' do
  title = params[:title]
  body = params[:content]

  memos = load_memos
  memo = memos[params[:id]]
  memo['title'] = title
  memo['body'] = body

  save_memos(memos)

  redirect '/memos'
end

delete '/memos/:id' do
  memos = load_memos
  memos.delete(params[:id])

  save_memos(memos)

  redirect '/memos'
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  @memo = load_memos[params[:id]]
  @id = params[:id]
  erb :show
end

get '/memos/:id/edit' do
  @memo = load_memos[params[:id]]
  @id = params[:id]
  erb :edit
end
