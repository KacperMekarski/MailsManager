module StatelessService
  extend ActiveSupport::Concern

  included do
    def self.constructor_arguments(*args)
      @arguments_for_constructor = Array.wrap(args)
    end

    def self.arguments_for_constructor
      @arguments_for_constructor ||= []
    end

    def self.call(*args)
      new(args).send(callable_method_name)
    end

    def self.callable_method_name
      @callable_method_name || :call
    end

    def self.call_via(method_name)
      @callable_method_name = method_name

      define_singleton_method method_name do |*args|
        call(*args)
      end
    end

    def self.dependencies
      @map_of_dependencies = block_given? ? yield : {}
    end

    def self.map_of_dependencies
      @map_of_dependencies
    end

    define_method :initialize do |arguments_values, *_options|
      initialize_dependencies
      initialize_arguments(arguments_values)
      override_dependencies(arguments_values)
    end
    private_class_method :new

    private

    def initialize_dependencies
      self.class.map_of_dependencies.to_h.each do |dependency_name, dependency|
        instance_variable_set("@#{dependency_name}", dependency)

        self.class.send(:attr_reader, dependency_name)
        self.class.send(:private,     dependency_name)
      end
    end

    def initialize_arguments(arguments_values)
      arguments_names = self.class.arguments_for_constructor

      Array
        .wrap(arguments_names)
        .zip(arguments_values)
        .each { |argument_name, value| instance_variable_set("@#{argument_name}", value) }

      self.class.send(:attr_reader, *arguments_names)
      self.class.send(:private,     *arguments_names)
    end

    def override_dependencies(arguments_values)
      potential_dependencies_hash = arguments_values.last

      return unless potential_dependencies_hash.respond_to?(:to_hash) && potential_dependencies_hash.to_hash.key?(:_dependencies)

      potential_dependencies_hash.to_hash.fetch(:_dependencies).each do |dependency_name, dependency|
        instance_variable_set("@#{dependency_name}", dependency)
      end
    end

    class << self
      alias_method :initialize_with, :constructor_arguments
    end
  end

  def call
    raise NotImplementedError
  end
end
