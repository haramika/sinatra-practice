# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'cgi'
require 'pg'

memos = {}

helpers do
  def h(text)
    CGI.escapeHTML(text.to_s)
  end
end

def connect_memos
  PG::Connection.new(host: 'localhost', dbname: 'memo')
end

def load_memos
  connect_memos.exec('SELECT * FROM memos')
end

def make_memos(memos)
  load_memos.each do |memo|
    memos[memo['id']] = memo
  end
end

def find_memo(memos, id)
  memos[id]
end

get '/memos' do
  make_memos(memos)

  @memos = memos
  erb :top
end

post '/memos/new' do
  id = SecureRandom.uuid
  title = params[:title]
  body = params[:content]

  connect_memos.exec_params('INSERT INTO memos (id, title, body) VALUES ($1, $2, $3)', [id, title, body])
  connect_memos.close

  redirect '/memos'
end

patch '/memos/:id' do
  title = params[:title]
  body = params[:content]

  connect_memos.exec_params('UPDATE memos SET title = $1 WHERE id = $2', [title, params[:id]])
  connect_memos.exec_params('UPDATE memos SET body = $1 WHERE id = $2', [body, params[:id]])
  connect_memos.close

  redirect '/memos'
end

delete '/memos/:id' do
  connect_memos.exec_params('DELETE FROM memos WHERE id = $1', [params[:id]])
  connect_memos.close

  redirect '/memos'
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  make_memos(memos)

  @memo = find_memo(memos, params[:id])
  erb :show
end

get '/memos/:id/edit' do
  make_memos(memos)

  @memo = find_memo(memos, params[:id])
  erb :edit
end
