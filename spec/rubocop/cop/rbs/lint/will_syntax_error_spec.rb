# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::WillSyntaxError, :config do
  describe 'class' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        class SuperClass < A[[void], self, class, instance]
                              ^^^^ `void` type is only allowed in return type or generics parameter
                                     ^^^^ `self` type is not allowed in this context
                                           ^^^^^ `class` type is not allowed in this context
                                                  ^^^^^^^^ `instance` type is not allowed in this context

        end
      RBS
    end

    it 'no registers an offense' do
      expect_no_offenses(<<~RBS)
        class SuperClass < A[void, B[void]]
        end
      RBS
    end
  end

  describe 'module' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        module SelfType : A[self, class, instance]
                            ^^^^ `self` type is not allowed in this context
                                  ^^^^^ `class` type is not allowed in this context
                                         ^^^^^^^^ `instance` type is not allowed in this context
        end
      RBS
    end

    it 'no registers an offense' do
      expect_no_offenses(<<~RBS)
        module SelfType : A[void]
        end
      RBS
    end
  end

  describe 'upper bound' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        class UpperBound[T < A[self, class, instance]]
                               ^^^^ `self` type is not allowed in this context
                                     ^^^^^ `class` type is not allowed in this context
                                            ^^^^^^^^ `instance` type is not allowed in this context
        end
      RBS
    end

    it 'no registers an offense' do
      expect_no_offenses(<<~RBS)
        class UpperBound[T < A[void]]
        end
      RBS
    end
  end

  describe 'method' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        class Foo
          def foo: (void) -> [void, void]
                    ^^^^ `void` type is only allowed in return type or generics parameter
                              ^^^^ `void` type is only allowed in return type or generics parameter
                                    ^^^^ `void` type is only allowed in return type or generics parameter
          def bar: (a: void) -> (void | void)
                       ^^^^ `void` type is only allowed in return type or generics parameter
                                 ^^^^ `void` type is only allowed in return type or generics parameter
                                        ^^^^ `void` type is only allowed in return type or generics parameter
          def baz: (*void) -> (void & void)
                     ^^^^ `void` type is only allowed in return type or generics parameter
                               ^^^^ `void` type is only allowed in return type or generics parameter
                                      ^^^^ `void` type is only allowed in return type or generics parameter
          def proc: (^(void) -> void | ^() { (void) [self: void] -> void } -> (void | void)) -> void
                       ^^^^ `void` type is only allowed in return type or generics parameter
                                              ^^^^ `void` type is only allowed in return type or generics parameter
                                                           ^^^^ `void` type is only allowed in return type or generics parameter
                                                                               ^^^^ `void` type is only allowed in return type or generics parameter
                                                                                      ^^^^ `void` type is only allowed in return type or generics parameter
          def untyped_function: (?) -> void
        end
      RBS
    end

    it 'no registers an offense' do
      expect_no_offenses(<<~RBS)
        class Foo
          def foo: () -> void
          def proc: (^(self, class, instance) { (self, class, instance) [self: self, class, instance] } -> void) -> void
        end
      RBS
    end
  end

  describe 'attribute' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        class Foo
          @a: void
              ^^^^ `void` type is only allowed in return type or generics parameter
          @b: [{ key: void }]
                      ^^^^ `void` type is only allowed in return type or generics parameter
          @c: { key: [void] }
                      ^^^^ `void` type is only allowed in return type or generics parameter
          @e: A[[void]]
                 ^^^^ `void` type is only allowed in return type or generics parameter
        end
      RBS

      expect_no_offenses(<<~RBS)
        class Foo
          @a: A[void]
          @b: self
          @c: class
          @d: instance
        end
      RBS
    end
  end

  describe 'mixin' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        class Foo
          include A[[self]]
                     ^^^^ `self` type is not allowed in this context
        end
      RBS
    end

    it 'no registers an offense' do
      expect_no_offenses(<<~RBS)
        class Foo
          include A[void]
        end
      RBS
    end
  end

  describe 'interface' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        interface _Foo
          def foo: () -> [void]
                          ^^^^ `void` type is only allowed in return type or generics parameter
          def bar: () -> (instance | class)
                          ^^^^^^^^ `instance` type is not allowed in this context
                                     ^^^^^ `class` type is not allowed in this context
          def baz: () -> class?
                         ^^^^^ `class` type is not allowed in this context
        end
      RBS
    end

    it 'no registers an offense' do
      expect_no_offenses(<<~RBS)
        interface _Foo
          def foo: () -> void
        end
      RBS
    end
  end

  describe 'const' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        class Foo
          CONST: [void, self, class, instance]
                  ^^^^ `void` type is only allowed in return type or generics parameter
                        ^^^^ `self` type is not allowed in this context
                              ^^^^^ `class` type is not allowed in this context
                                     ^^^^^^^^ `instance` type is not allowed in this context
          PROC: ^(self, class, instance) -> [self, class, instance]
                  ^^^^ `self` type is not allowed in this context
                        ^^^^^ `class` type is not allowed in this context
                               ^^^^^^^^ `instance` type is not allowed in this context
                                             ^^^^ `self` type is not allowed in this context
                                                   ^^^^^ `class` type is not allowed in this context
                                                          ^^^^^^^^ `instance` type is not allowed in this context
        end
      RBS
    end

    it 'no registers an offense' do
      expect_no_offenses(<<~RBS)
        class Foo
          CONST: 123
          PROC: ^() -> void
        end
      RBS
    end
  end

  describe 'global' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        class Foo
          $global: [void, self, class, instance]
                    ^^^^ `void` type is only allowed in return type or generics parameter
                          ^^^^ `self` type is not allowed in this context
                                ^^^^^ `class` type is not allowed in this context
                                       ^^^^^^^^ `instance` type is not allowed in this context
        end
      RBS
    end

    it 'no registers an offense' do
      expect_no_offenses(<<~RBS)
        class Foo
          $global: 123
        end
      RBS
    end
  end

  describe 'alias' do
    it 'registers an offense' do
      expect_offense(<<~RBS)
        class Foo
          type t = [void, self, class, instance]
                    ^^^^ `void` type is only allowed in return type or generics parameter
                          ^^^^ `self` type is not allowed in this context
                                ^^^^^ `class` type is not allowed in this context
                                       ^^^^^^^^ `instance` type is not allowed in this context
        end
      RBS
    end

    it 'no registers an offense' do
      expect_no_offenses(<<~RBS)
        class Foo
          type foo = bar
        end
      RBS
    end
  end
end
