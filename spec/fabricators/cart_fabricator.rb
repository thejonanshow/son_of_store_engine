# == Schema Information
#
# Table name: carts
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  address_id :integer
#  store_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#


Fabricator(:cart)
