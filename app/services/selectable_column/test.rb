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
        # Define all associations that need to preloaded
        preload_associations = [{:organizations=> [:products, :user]}, :introduction, {:wife => [:father, :mother]}]
        # Define the columns that you needed specificly for the associations you want.
        specify_selectable_columns = {
          user: [:created_at],
          organizations: [:updated_at],
          products: [:price],
          introduction: [:created_at],
          wife: [:created_at],
          parent: [:created_at]
        }
        # Get the columns that will be selectec for every association, it's a Hash
        association_columns = SelectableColumn::Model.new(model: User,
                                                          associations: preload_associations,
                                                          asso_selects: specify_selectable_columns
                                                         ).selects_mapping
        puts 'selectable columns:'
        puts association_columns
        preloader = ActiveRecord::Associations::Preloader.new
        # Load all the associations data at once.
        preloader.selectable_preload(relation, preload_associations, association_columns)
      end

      # It can also be excuted in batches, not at once.
      # Divide the specify_selectable_columns and association_columns into smaller pieces, then call the
      # selectable_preload method many times, you will get the same results.
      def user_selectable_batchs
        relation = User.where("id > 0")
        user_default_selectable_columns = SelectableColumn::Columns.single_mapping(User)
        user_need_columns = [:created_at]
        relation = relation.select(user_default_selectable_columns + user_need_columns)
        preloader = ActiveRecord::Associations::Preloader.new
        # first batch
        preload_associations = [{:organizations=> [:products, :user]}]

        specify_selectable_columns = {
          user: [:created_at],
          organizations: [:updated_at],
          products: [:price],
        }

        association_columns = SelectableColumn::Model.new(model: User,
                                                          associations: preload_associations,
                                                          asso_selects: specify_selectable_columns
                                                         ).selects_mapping

        # Do other things you want to.

        # load first batch data
        preloader.selectable_preload(relation, preload_associations, association_columns)
        # second batch
        preload_associations = [:introduction]

        specify_selectable_columns = {
          introduction: [:created_at]
        }

        association_columns = SelectableColumn::Model.new(model: User,
                                                          associations: preload_associations,
                                                          asso_selects: specify_selectable_columns
                                                         ).selects_mapping

        # Load second batch data
        preloader.selectable_preload(relation, preload_associations, association_columns)

        # Do other things you want to.

        preload_associations = [{:wife => [:father, :mother]}]
        # it can't work at the association that depends on the `through`,
        # so the associations below will select all columns.
        specify_selectable_columns = {
          wife: [:created_at],
          parent: [:created_at]
        }
        # Load third batch data
        association_columns = SelectableColumn::Model.new(model: User,
                                                          associations: preload_associations,
                                                          asso_selects: specify_selectable_columns
                                                         ).selects_mapping

        preloader.selectable_preload(relation, preload_associations, association_columns)
      end

    end # end of self

  end
end
