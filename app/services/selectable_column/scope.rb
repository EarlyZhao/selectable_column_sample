module SelectableColumn
  class Scope

    class << self
      # https://github.com/rails/rails/blob/v4.2.10/activerecord/lib/active_record/associations/preloader.rb
      # 4.2 ~
      def preloader_scope_4_2(columns)
        return nil if columns.blank?
        struct = ActiveRecord::Associations::Preloader::NULL_RELATION.clone
        struct.values = {values: {select: Array(columns)}}
        struct
      end
      # 5.1 ~
      def preloader_scope(columns)
        return nil if columns.blank?
        {select: Array(columns)}
      end

    end # end of self

  end
end