require "extended_joins_impl/version"

module ExtendedJoinsImpl
  def extended_joins(join_type, table, params={})
    on_key = params[:on] || default_condition(table.table_name, params[:as])

    joins_table_name = params[:as] || table.table_name
    table_arel = table.arel.as(joins_table_name.to_s)

    condition = nil
    on_key.each do |left, right|
      right_value = right.class == Symbol ? table_arel[right.to_sym] : right

      a_condition = self.arel_table[left.to_sym].eq(right_value)
      if condition.present?
        condition = condition.and(a_condition)
      else
        condition = a_condition
      end
    end
    if params[:where].present?
      params[:where].each {|right, value| condition = condition.and(table_arel[right.to_sym].eq(value)) }
    end

    join_node = (join_type == :outer) ? Arel::Nodes::OuterJoin : Arel::Nodes::InnerJoin
    join_state = join_node.new( table_arel, Arel::Nodes::On.new(condition))

    result = self.joins(join_state)
    result = result.tap {|condition| condition.bind_values = table.bind_values }
    result
  end

  private
  def default_condition(table_name, alias_name)
    association = reflect_on_association(alias_name.to_sym) if alias_name.present?
    if association.blank?
      association = reflect_on_association(table_name.singularize.to_sym) ||
          reflect_on_association(table_name.to_sym)
    end

    options = association.try(:options) || {}
    if association.try(:macro) == :belongs_to
      {(options[:foreign_key] || "#{table_name.singularize}_id") => (options[:primary_key] || :id)}
    else
      {(options[:primary_key] || :id) => (options[:foreign_key] || "#{self.table_name.singularize}_id".to_sym)}
    end
  end
end

module ActiveRecord
  class Relation
    include ExtendedJoinsImpl
  end
end