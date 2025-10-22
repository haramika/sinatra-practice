# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'cgi'
require 'pg'

helpers do
  def h(text)
    CGI.escapeHTML(text.to_s)
  end
end

def connect_memos
  PG::Connection.new(host: 'localhost', dbname: 'memo')
end

def load_memos
  connect_memos.exec('SELECT * FROM memos ORDER BY id ASC')
end

def find_memos(id)
  connect_memos.exec_params('SELECT * FROM memos WHERE id = $1', [id])
end

get '/memos' do
  @memos = load_memos

  erb :top
end

post '/memos/new' do
  title = params[:title]
  body = params[:content]

  connect_memos.exec_params('INSERT INTO memos (title, body) VALUES ($1, $2)', [title, body])
  connect_memos.close
  redirect '/memos'
end

patch '/memos/:id' do
  title = params[:title]
  body = params[:content]

  connect_memos.exec_params('UPDATE memos SET title = $1, body = $2 WHERE id = $3', [title, body, params[:id]])
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
  @memo = find_memos(params[:id])[0]

  erb :show
end

get '/memos/:id/edit' do
  @memo = find_memos(params[:id])[0]
  
  erb :edit
end
