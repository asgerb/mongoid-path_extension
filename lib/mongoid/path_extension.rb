require 'mongoid'

module Mongoid
  class PathExtension < String
    def initialize(str)
      super str.to_s
      @str = str.to_s
    end

    def components
      return [] unless @str.present?
      @str.split('/')
    end

    def root
      components.first
    end

    def permalink
      components.last
    end

    def absolute
      ['/', @str].join
    end

    def has_parent?
      components.length > 1
    end

    def ancestor_paths
      return unless has_parent?
      res = []
      components[0..-2].each_with_index do |component, index|
        res << components[0..index].join('/')
      end
      res
    end

    def parent_path
      return unless has_parent?
      components[0..-2].join('/')
    end

    def parent_permalink
      return unless has_parent?
      components[-2]
    end

    class << self
      def demongoize(value)
        PathExtension.new(value)
      end

      def mongoize(value)
        case value
        when PathExtension then value.mongoize
        else value
        end
      end

      def evolve(value)
        case value
        when PathExtension then value.mongoize
        else value
        end
      end
    end
  end
end
