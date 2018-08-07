# https://github.com/rails/rails/blob/v4.2.10/activerecord/lib/active_record/associations/preloader.rb
module ActiveRecord

  module Associations

    class Preloader

      def selectable_preload(records, associations, preload_scope = nil)
        records ||= Customer.where(id: [2468,3677])
        records       = Array.wrap(records).compact.uniq
        associations  = Array.wrap(associations)
        #preload_scope = preload_scope #|| NULL_RELATION

        if records.empty?
          []
        else
          associations.flat_map { |association|
            spreloaders_on association, records, preload_scope
          }
        end
        # the relation can't lazy load anymore
        records
      end

      private

      def spreloaders_on(association, records, scope)
        case association
        when Hash
          spreloaders_for_hash(association, records, scope)
        when Symbol
          spreloaders_for_one(association, records, scope)
        when String
          spreloaders_for_one(association.to_sym, records, scope)
        else
          raise ArgumentError, "#{association.inspect} was not recognised for preload"
        end
      end

      def spreloaders_for_hash(association, records, scope)
        association.flat_map { |parent, child|
          loaders = spreloaders_for_one parent, records, scope

          recs = loaders.flat_map(&:preloaded_records).uniq
          loaders.concat Array.wrap(child).flat_map { |assoc|
            spreloaders_on assoc, recs, scope
          }
          loaders
        }
      end

      # Not all records have the same class, so group then preload group on the reflection
      # itself so that if various subclass share the same association then we do not split
      # them unnecessarily
      #
      # Additionally, polymorphic belongs_to associations can have multiple associated
      # classes, depending on the polymorphic_type field. So we group by the classes as
      # well.

      # https://github.com/rails/rails/blob/v4.2.10/activerecord/lib/active_record/associations/preloader.rb#L142
      def spreloaders_for_one(association, records, scope)
        grouped_records(association, records).flat_map do |reflection, klasses|
          klasses.map do |rhs_klass, rs|

            single_scope = scope
            if scope && scope.class == Hash
              single_scope = scope[association]
            end
            # Rails 5.1 and lower version need the following code
            single_scope ||= NULL_RELATION

            loader = preloader_for(reflection, rs, rhs_klass).new(rhs_klass, rs, reflection, single_scope)
            loader.run self
            loader
          end
        end
      end


    end

  end

end
