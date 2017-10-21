# Title  : Example to processing CSV using Ruby Meta Programming
# Author : Arifin
# URL    : arfn.me

require 'csv'

class FeedGenerator
  attr_accessor :source, :feed, :current_row

  def initialize(source_name, feed_name)
    @source = CSV.read(source_name, headers: true)
    @current_row = Row.new

    # define method by header of source file
    @source.headers.each do |column|
      @current_row.instance_eval do
        define_singleton_method(column) do
          self.row[column]
        end
      end
    end

    @feed = CSV.open(feed_name, 'wb+')
    @feed << columns
  end

  def generate_feed
    @source.each do |row|
      @current_row.row = row
      @feed << columns.map do |c|
        @current_row.send(c)
      end
    end
  end

  def columns; raise 'unimplimented'; end

  class Row
    attr_accessor :row

    # you can define unrecognized column mapping below
    def product_id; id; end
    def product_name; name; end
    def image_url; img_url; end
    def title; name; end

    def category_tree
      [cat_1, cat_2].join(' > ')
    end

    def category
      cat_1 || cat_2
    end

    def deal_price
      price.to_i - discount.to_i
    end
  end
end

class StarkFeedGenerator < FeedGenerator
  def columns; %w(id product_name category price discount img_url url); end
end

class BoltonFeedGenerator < FeedGenerator
  def columns; %w(product_id name price deal_price category_tree image_url url); end
end

class LannisterFeedGenerator < FeedGenerator
  def columns; %w(id title price discount category img_url url); end
end

class GreyjoyFeedGenerator < FeedGenerator
  def columns; %w(id name price discount image_url url); end
end

StarkFeedGenerator.new('products.csv', 'stark_feed.csv').generate_feed
BoltonFeedGenerator.new('products.csv', 'bolton_feed.csv').generate_feed
LannisterFeedGenerator.new('products.csv', 'lannister_feed.csv').generate_feed
GreyjoyFeedGenerator.new('products.csv', 'greyjoy_feed.csv').generate_feed
