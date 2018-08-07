module SelectableColumn
  class Test

    class << self
      def user_selectable
        puts "
          This is a example for selectable columns, you can see the selectable columns in SQL, if the development mode on.
          the preload associations are  [{:organizations=> [:products, :user]}, :introduction, {:wife => [:parent, :mother]}],
          and the selectable columns works will except the {:wife => [:parent, :mother]} which depends on the through association.
          You can select the columns by dynamic, instead of select * .

        "
        relation = User.where("id > 0")
        user_default_selectable_columns = SelectableColumn::Columns.single_mapping(User)
        user_need_columns = [:created_at]
        relation = relation.select(user_default_selectable_columns + user_need_columns)
        preload_associations = [{:organizations=> [:products, :user]}, :introduction, {:wife => [:father, :mother]}]
        specify_selectable_columns = {
          user: [:created_at],
          organizations: [:updated_at],
          products: [:price],
          introduction: [:created_at],
          wife: [:created_at],
          parent: [:created_at]
        }

        association_columns = SelectableColumn::Model.new(model: User,
                                                          associations: preload_associations,
                                                          asso_selects: specify_selectable_columns
                                                         ).selects_mapping
        puts 'selectable columns:'
        puts association_columns
        preloader = ActiveRecord::Associations::Preloader.new
        preloader.selectable_preload(relation, preload_associations, association_columns)
      end

    end # end of self

  end
end
