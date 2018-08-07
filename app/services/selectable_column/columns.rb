module SelectableColumn
  class Columns
    # define the default columns for the Model you want to customise
    UserSelect = [:id, :name].freeze
    OrganizationSelect = [:id, :owner_id, :name]
    IntroductionSelect = [:id, :user_id, :digest]
    ProductSelect = [:id, :name, :organization_id]

    # define the associations mapping of User
    UserMapping = {
      user: UserSelect,
      parent: UserSelect,
      father: UserSelect,
      mother: UserSelect,
      female: UserSelect,
      male: UserSelect,
      wife: UserSelect,
      husband: UserSelect,
      organizations: OrganizationSelect,
      introduction: IntroductionSelect,
      products: ProductSelect
    }

    def self.asso_mapping(klass, asso=nil)
      if asso
        self.const_get("#{klass}Mapping")[asso.to_sym]
      else
        self.const_get("#{klass}Mapping")
      end
    rescue NameError
      nil
    end

    def self.single_mapping(klass)
      self.const_get("#{klass}Select")
    rescue NameError
      nil
    end

  end
end