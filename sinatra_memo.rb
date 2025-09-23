# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'

get '/memo/top' do
  erb :top_page
end

get '/memo/new_memo' do
  erb :new_memo
end

get '/memo/show_memo1' do
  erb :show_memo1
end

get '/memo/edit_memo1' do
  erb :edit_memo1
end
