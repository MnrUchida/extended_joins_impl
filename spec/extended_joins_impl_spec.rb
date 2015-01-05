# coding: utf-8
require 'spec_helper'
require 'extended_joins_impl'

describe ExtendedJoinsImpl do

  it "inner join" do
    sql = if ActiveRecord::VERSION::MAJOR >= 4
            User.extended_joins(:inner, Type.all).to_sql
          else
            User.extended_joins(:inner, Type.scoped).to_sql
          end
    expect(sql).to include "INNER JOIN"
    expect(sql).to include "\"users\".\"type_id\" = types.\"id\""
  end

  it "left outer join" do
    sql = if ActiveRecord::VERSION::MAJOR >= 4
            User.extended_joins(:outer, Type.all).to_sql
          else
            User.extended_joins(:outer, Type.scoped).to_sql
          end
    expect(sql).to include "LEFT OUTER JOIN"
    expect(sql).to include "\"users\".\"type_id\" = types.\"id\""
  end

  it "subquery join" do
    sql = User.extended_joins(:outer, Type.where(id: 3)).to_sql
    expect(sql).to include "LEFT OUTER JOIN"
    expect(sql).to include "\"users\".\"type_id\" = types.\"id\""
    expect(sql).to include "WHERE \"types\".\"id\" = 3"
  end

  it "join alias" do
    sql = User.extended_joins(:outer, Type.where(id: 3), as: "user_types").to_sql
    expect(sql).to include "LEFT OUTER JOIN"
    expect(sql).to include "\"users\".\"type_id\" = user_types.\"id\""
    expect(sql).to include "WHERE \"types\".\"id\" = 3"
  end

  it "join on condition" do
    sql = if ActiveRecord::VERSION::MAJOR >= 4
            User.extended_joins(:inner, Note.all, on: {code: :user_code}).to_sql
          else
            User.extended_joins(:inner, Note.scoped, on: {code: :user_code}).to_sql
          end
    expect(sql).to include "INNER JOIN"
    expect(sql).to include "\"users\".\"code\" = notes.\"user_code\""
  end

  it "join on constant" do
    sql = if ActiveRecord::VERSION::MAJOR >= 4
            User.extended_joins(:inner, Note.all, where: {id: 3, user_code: 4}).to_sql
          else
            User.extended_joins(:inner, Note.scoped, where: {id: 3, user_code: 4}).to_sql
          end
    expect(sql).to include "INNER JOIN"
    expect(sql).to include "\"users\".\"id\" = notes.\"user_id\""
    expect(sql).to include "notes.\"id\" = 3"
    expect(sql).to include "notes.\"user_code\" = 4"
  end

  it "join with association" do
    sql = if ActiveRecord::VERSION::MAJOR >= 4
            User.extended_joins(:inner, Note.all, as: "user_notes").to_sql
          else
            User.extended_joins(:inner, Note.scoped, as: "user_notes").to_sql
          end
    expect(sql).to include "INNER JOIN"
    expect(sql).to include "\"users\".\"code\" = user_notes.\"user_code\""
  end

end
