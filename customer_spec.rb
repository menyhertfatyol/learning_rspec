# Previously: https://books.google.hu/books?id=0dvJDAAAQBAJ&pg=PA27&lpg=PA29#v=onepage&q&f=false

# https://books.google.hu/books?id=0dvJDAAAQBAJ&pg=PA29&lpg=PA29#v=onepage&q&f=false

require 'rspec'
require 'rspec/expectations'
require_relative 'customer'

RSpec::Matchers.define :be_discounted do |hsh|
  match do |customer|
    @customer = customer
    @actual = hsh.keys.inject({}) do |memo, product, _|
      memo[product] = @customer.discount_amount_for product
      memo
    end

    differ = RSpec::Support::Differ.new

    @difference = differ.diff_as_object(hsh, @actual)
    @difference.to_s.chomp == ""
  end

  failure_message do |actual|
    "expected #{@customer} to have discounts:\n" +
    " #{actual.inspect}.\n" +
    "Diff: \n" +
    @difference
  end
end

RSpec.describe Customer do
  describe 'discounts' do
    let(:discounts) { {"foo123" => 0.1} }
    let(:customer) { Customer.new discounts: discounts }

    it "detects when customer has a discount" do
      expect(customer).to be_discounted('foo123' => 0.2)
    end
  end
end
