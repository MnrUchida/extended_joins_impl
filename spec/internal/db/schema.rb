# coding: utf-8
ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
    t.references :type
    t.integer :code
    t.timestamps
  end

  create_table :types, :force => true do |t|
    t.timestamps
  end

  create_table :notes, :force => true do |t|
    t.references :user
    t.integer :user_code
  end
end
