# coding: utf-8
class User < ActiveRecord::Base
  belongs_to :type
  has_many :user_notes,
           class_name: "Note",
           primary_key: :code,
           foreign_key: :user_code

end

class Type < ActiveRecord::Base
end

class Note < ActiveRecord::Base
end