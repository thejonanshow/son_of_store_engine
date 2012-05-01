require 'spec_helper'

describe Category do
  let!(:store) { Fabricate(:store) }
  let!(:category) { Fabricate(:category, :store => store) }
  let!(:product)  { Fabricate(:product, :store => store) }
  let!(:admin_user) { Fabricate(:user) }
  let!(:store) { Fabricate(:store, :users => [admin_user]) }
  let!(:category) { Fabricate(:category, :store => store) }
  let!(:product)  { Fabricate(:product, :store => store) }

  before(:each) do
    store.add_admin(admin_user)
  end

  context "new" do
    it "allows for a product to be added to a category" do

    end
  end
  
  context "show" do
    it "lists all of the products for that category" do
      category.add_product(product)
      visit category_path(store, category)
      page.should have_content(product.title)
    end
  end

  context "index" do
    it "lists all the categories" do
      visit products_path(store)
      click_link "Browse by Category"
      page.should have_content("#{category.name}")
    end
  end
end