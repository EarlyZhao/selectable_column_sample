module SelectableColumn
  class Model

    def initialize(model: , associations: [], asso_selects: {})
      @model = model
      @associations = Array(associations)
      @association_selects = asso_selects
      @preloader_scopes = {}
    end

    def selects_mapping
      # if a association is repeat, then later one will be left
      select_associations(@associations, @model)

      @preloader_scopes
    end

    def single_columns(select_columns=[])
      default = SelectableColumn::Columns.single_mapping(@model)
      # if default columns is blank, use all columns
      if default.present?
        (default + select_columns).map(&:to_sym) & @model.column_names.map(&:to_sym)
      else
        @model.column_names.map(&:to_sym)
      end
    end

    private
    def select_associations(associations, parent)
      Array(associations).each do |asso|
        case asso
        when String, Symbol
          deal_single_asso(asso, parent)
        when Hash
          deal_hash_asso(asso, parent)
        else
          raise "Not support this association type: #{asso.class}"
        end
      end
    end

    def deal_single_asso(association, parent)
      # ensure the association is exist
      if current_asso = parent.reflect_on_association(association)
        default_columns = SelectableColumn::Columns.asso_mapping(@model, association)
        if default_columns.present?
          needed_columns = @association_selects[association] || []
          # ensure the columns belongs to the model
          safe_columns = (needed_columns + default_columns).map(&:to_sym) & current_asso.class_name.constantize.column_names.map(&:to_sym)
          if safe_columns.present?
            @preloader_scopes[association] = SelectableColumn::Scope.preloader_scope(safe_columns)
          end
        end
      end
    end
    #{parent: child}
    def deal_hash_asso(association, parent)
      association.each do |key, value|
        deal_single_asso(key, parent)
        parent = parent.reflect_on_association(key).class_name.constantize
        select_associations(value, parent)
      end
    end

  end
end