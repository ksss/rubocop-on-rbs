# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::TypeParamsArity, :config do
  describe 'class' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        class Foo[T < ::Array] < Array
                      ^^^^^^^ Type `::Array` is generic but used as a non generic type.
          include ::Enumerable[A]
          include ::Enumerable[A, B]
          ^^^^^^^^^^^^^^^^^^^^^^^^^^ Type `::Enumerable` expects 1 arguments, but 2 arguments are given.
        end
        class Bar[T < Array] < ::Array
                               ^^^^^^^ Type `::Array` is generic but used as a non generic type.
        end
      RBS
    end
  end

  describe 'module' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        module Foo[T < ::Array] : ::Array
                       ^^^^^^^ Type `::Array` is generic but used as a non generic type.
                                  ^^^^^^^ Type `::Array` is generic but used as a non generic type.
          include ::Enumerable[A, B]
          ^^^^^^^^^^^^^^^^^^^^^^^^^^ Type `::Enumerable` expects 1 arguments, but 2 arguments are given.
        end
      RBS
    end
  end

  describe 'interface' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        interface _Foo[T < ::Array]
                           ^^^^^^^ Type `::Array` is generic but used as a non generic type.
          include ::_Each[A, B]
          ^^^^^^^^^^^^^^^^^^^^^ Type `::_Each` expects 1 arguments, but 2 arguments are given.
        end
      RBS
    end
  end

  describe 'constant' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        A: ::Array
           ^^^^^^^ Type `::Array` is generic but used as a non generic type.
        PROC: ^(::Array) { (::Array) [self: ::Array] -> ::Array} -> ::Array
                ^^^^^^^ Type `::Array` is generic but used as a non generic type.
                            ^^^^^^^ Type `::Array` is generic but used as a non generic type.
                                            ^^^^^^^ Type `::Array` is generic but used as a non generic type.
                                                        ^^^^^^^ Type `::Array` is generic but used as a non generic type.
                                                                    ^^^^^^^ Type `::Array` is generic but used as a non generic type.
        RECORD: { a: ::Array }
                     ^^^^^^^ Type `::Array` is generic but used as a non generic type.
      RBS
    end
  end

  describe 'global' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        $a: ::Array
            ^^^^^^^ Type `::Array` is generic but used as a non generic type.
      RBS
    end
  end

  describe 'type alias' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        type foo = ::Array
                   ^^^^^^^ Type `::Array` is generic but used as a non generic type.
        type bar = ::array[A, B]
                   ^^^^^^^^^^^^^ Type `::array` expects 1 arguments, but 2 arguments are given.
      RBS
    end
  end

  describe 'method definition' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        class Foo
          def foo: (::Array, a: ::_Each, **::range) -> (::Array | ::Set)?
                    ^^^^^^^ Type `::Array` is generic but used as a non generic type.
                                ^^^^^^^ Type `::_Each` is generic but used as a non generic type.
                                           ^^^^^^^ Type `::range` is generic but used as a non generic type.
                                                        ^^^^^^^ Type `::Array` is generic but used as a non generic type.
                                                                  ^^^^^ Type `::Set` is generic but used as a non generic type.
        end
      RBS
    end
  end
end
