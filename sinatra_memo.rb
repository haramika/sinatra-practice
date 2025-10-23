# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'cgi'
require 'pg'

CONN = PG::Connection.new(host: 'localhost', dbname: 'memo')

helpers do
  def h(text)
    CGI.escapeHTML(text.to_s)
  end
end

def load_memos
  sql = <<~SQL
    SELECT *
    FROM memos
    ORDER BY id
  SQL
  CONN.exec(sql)
end

def make_prepared_statement(sql, values)
  CONN.exec_params(sql, values)
end

def find_memo(id)
  sql = <<~SQL
    SELECT *
    FROM memos
    WHERE id = $1
  SQL
  make_prepared_statement(sql, [id])
end

get '/memos' do
  @memos = load_memos

  erb :top
end

post '/memos/new' do
  title = params[:title]
  body = params[:content]

  sql = 'INSERT INTO memos (title, body) VALUES ($1, $2)'
  make_prepared_statement(sql, [title, body])
  redirect '/memos'
end

patch '/memos/:id' do
  title = params[:title]
  body = params[:content]

  sql = 'UPDATE memos SET title = $1, body = $2 WHERE id = $3'
  make_prepared_statement(sql, [title, body, params[:id]])
  redirect '/memos'
end

delete '/memos/:id' do
  sql = 'DELETE FROM memos WHERE id = $1'
  make_prepared_statement(sql, [params[:id]])
  redirect '/memos'
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  @memo = find_memo(params[:id])[0]
  erb :show
end

get '/memos/:id/edit' do
  @memo = find_memo(params[:id])[0]
  erb :edit
end
