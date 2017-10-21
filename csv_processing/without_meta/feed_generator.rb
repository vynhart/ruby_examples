# Title  : Example to processing CSV without using Ruby Meta Programming
# Author : Arifin
# URL    : arfn.me

require 'csv'

class FeedGenerator
  attr_accessor :source

  def initialize(file_name)
    @source = CSV.read(file_name, headers: true)
  end
end

class StarkFeedGenerator < FeedGenerator
  COLUMNS = %w(id product_name category price discount img_url url).freeze
  def generate_feed
    new_feed = CSV.open('stark_feed.csv', 'wb+')
    new_feed << COLUMNS
    @source.each do |row|
      # manually mapping source file to new file
      new_feed << [
        row['id'],
        row['name'],
        row['cat_2'] || row['cat_1'], # take the last category
        row['price'],
        row['discount'],
        row['img_url'],
        row['url']
      ]
    end
    new_feed.close
  end
end

class BoltonFeedGenerator < FeedGenerator
  COLUMNS = %w(product_id name price deal_price category_tree image_url url)
  def generate_feed
    new_feed = CSV.open('bolton_feed.csv', 'wb+')
    new_feed << COLUMNS
    @source.each do |row|
      # manually mapping source file to new file
      new_feed << [
        row['id'],
        row['name'],
        row['price'],
        row['price'].to_i - row['discount'].to_i,
        [row['cat_1'], row['cat_2']].join(" > "),
        row['img_url'],
        row['url']
      ]
    end
    new_feed.close
  end
end

class LannisterFeedGenerator < FeedGenerator
  COLUMNS = %w(id title price discount category img_url url)

  def generate_feed
    new_feed = CSV.open('lannister_feed.csv', 'wb+')
    new_feed << COLUMNS
    @source.each do |row|
      # manually mapping source file to new file
      new_feed << [
        row['id'],
        row['name'],
        row['price'],
        row['discount'].to_i,
        row['cat_2'] || row['cat_1'], # take the last category
        row['img_url'],
        row['url']
      ]
    end
    new_feed.close
  end
end

class GreyjoyFeedGenerator < FeedGenerator
  COLUMNS = %w(id name price discount image_url url)

  def generate_feed
    new_feed = CSV.open('greyjoy_feed.csv', 'wb+')
    new_feed << COLUMNS
    @source.each do |row|
      # manually mapping source file to new file
      new_feed << [
        row['id'],
        row['name'],
        row['price'],
        row['discount'].to_i,
        row['img_url'],
        row['url']
      ]
    end
    new_feed.close
  end
end

StarkFeedGenerator.new('products.csv').generate_feed
BoltonFeedGenerator.new('products.csv').generate_feed
LannisterFeedGenerator.new('products.csv').generate_feed
GreyjoyFeedGenerator.new('products.csv').generate_feed
