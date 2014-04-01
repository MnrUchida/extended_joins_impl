# coding: utf-8
require 'spec_helper'
require 'extended_joins_impl'

describe ExtendedJoinsImpl do

  it "inner join" do
    sql = User.where(nil).extended_joins(:inner, Type.where(nil)).to_sql
    expect(sql).to include "INNER JOIN"
    expect(sql).to include "\"users\".\"type_id\" = types.\"id\""
  end

  it "left outer join" do
    sql = User.where(nil).extended_joins(:outer, Type.where(nil)).to_sql
    expect(sql).to include "LEFT OUTER JOIN"
    expect(sql).to include "\"users\".\"type_id\" = types.\"id\""
  end

  it "subquery join" do
    sql = User.where(nil).extended_joins(:outer, Type.where(id: 3)).to_sql
    expect(sql).to include "LEFT OUTER JOIN"
    expect(sql).to include "\"users\".\"type_id\" = types.\"id\""
    expect(sql).to include "WHERE \"types\".\"id\" = 3"
  end

  it "join alias" do
    sql = User.where(nil).extended_joins(:outer, Type.where(id: 3), as: "user_types").to_sql
    expect(sql).to include "LEFT OUTER JOIN"
    expect(sql).to include "\"users\".\"type_id\" = user_types.\"id\""
    expect(sql).to include "WHERE \"types\".\"id\" = 3"
  end

  it "join on condition" do
    sql = User.where(nil).extended_joins(:inner, Note.where(nil), on: {code: :user_code}).to_sql
    expect(sql).to include "INNER JOIN"
    expect(sql).to include "\"users\".\"code\" = notes.\"user_code\""
  end

  it "join on constant" do
    sql = User.where(nil).extended_joins(:inner, Note.where(nil), where: {id: 3, user_code: 4}).to_sql
    expect(sql).to include "INNER JOIN"
    expect(sql).to include "\"users\".\"id\" = notes.\"user_id\""
    expect(sql).to include "notes.\"id\" = 3"
    expect(sql).to include "notes.\"user_code\" = 4"
  end

  it "join with association" do
    sql = User.where(nil).extended_joins(:inner, Note.where(nil), as: "user_notes").to_sql
    expect(sql).to include "INNER JOIN"
    expect(sql).to include "\"users\".\"code\" = user_notes.\"user_code\""
  end

end
