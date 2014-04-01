# coding: utf-8
require 'spec_helper'
require 'extended_joins_impl'

describe ExtendedJoinsImpl do

  it "inner join" do
    sql = User.where(nil).extended_joins(:inner, Type.where(nil)).to_sql
    expect(sql).to include "INNER JOIN"
    expect(sql).to include "users.type_id = type.id"
  end
end
