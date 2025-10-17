# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'cgi'

memos_file = 'memos.json'

helpers do
  def h(text)
    CGI.escapeHTML(text.to_s)
  end
end

def load_memos(file)
  JSON.parse(File.read(file))
end

def save_memos(file, data)
  File.open(file, 'w') do |f|
    JSON.dump(data, f)
  end
end

get '/memos' do
  empty_memos = {}
  save_memos(memos_file, empty_memos) if !File.exist?(memos_file)

  @memos = load_memos(memos_file)
  @id = params[:id]
  erb :top
end

post '/memos/new' do
  title = params[:title]
  body = params[:content]

  memos = load_memos(memos_file)
  memos[SecureRandom.uuid] = { 'title' => title, 'body' => body }

  save_memos(memos_file, memos)

  redirect '/memos'
end

patch '/memos/:id' do
  title = params[:title]
  body = params[:content]

  memos = load_memos(memos_file)
  memo = memos[params[:id]]
  memo['title'] = title
  memo['body'] = body

  save_memos(memos_file, memos)

  redirect '/memos'
end

delete '/memos/:id' do
  memos = load_memos(memos_file)
  memos.delete(params[:id])

  save_memos(memos_file, memos)

  redirect '/memos'
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  @memo = load_memos(memos_file)[params[:id]]
  @id = params[:id]
  erb :show
end

get '/memos/:id/edit' do
  @memo = load_memos(memos_file)[params[:id]]
  @id = params[:id]
  erb :edit
end
