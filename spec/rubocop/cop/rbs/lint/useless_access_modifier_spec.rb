# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::UselessAccessModifier, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Public
        public
        ^^^^^^ Useless `public` access modifier.
      end

      module PublicModule
        public
        ^^^^^^ Useless `public` access modifier.
      end

      class PublicBeforeDef
        public
        ^^^^^^ Useless `public` access modifier.

        def foo: () -> void
      end

      class Private
        private
        ^^^^^^^ Useless `private` access modifier.
      end

      class PrivatePublic
        private
        public
        ^^^^^^ Useless `public` access modifier.
      end

      class DoublePrivate
        private
        private
        ^^^^^^^ Useless `private` access modifier.
        def foo: () -> void
      end

      class PrivateBeforeIgnores
        private
        ^^^^^^^ Useless `private` access modifier.

        def self.foo: () -> void
        alias bar foo
        include Mod
      end
    RBS

    expect_correction(<<~RBS)
      class Public
      end

      module PublicModule
      end

      class PublicBeforeDef

        def foo: () -> void
      end

      class Private
      end

      class PrivatePublic
      end

      class DoublePrivate
        private
        def foo: () -> void
      end

      class PrivateBeforeIgnores

        def self.foo: () -> void
        alias bar foo
        include Mod
      end
    RBS
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RBS)
      class Public
        private
        def foo: () -> void
        public
        def bar: () -> void
      end

      class Private
        private
        def foo: () -> void
      end
    RBS
  end
end
