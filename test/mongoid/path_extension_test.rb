require 'test_helper'

class PathExtensionTest
  include Mongoid::Document
  field :path, type: Mongoid::PathExtension
end

describe Mongoid::PathExtension do
  let(:path) { 'LevelOne/LevelTwo/LevelThree' }
  subject { PathExtensionTest.new(path: path) }

  it 'preserves it' do
    _(subject.path).must_equal path
  end

  it '#components' do
    _(subject.path.components).must_equal %w(LevelOne LevelTwo LevelThree)
  end

  it '#absolute' do
    _(subject.path.absolute).must_equal "/#{path}"
  end

  it '#root' do
    _(subject.path.root).must_equal 'LevelOne'
  end

  it '#permalink' do
    _(subject.path.permalink).must_equal 'LevelThree'
  end

  it '#parent_path' do
    _(subject.path.parent_path).must_equal 'LevelOne/LevelTwo'
  end

  it '#parent_permalink' do
    _(subject.path.parent_permalink).must_equal 'LevelTwo'
  end

  it '#ancestor_paths' do
    _(subject.path.ancestor_paths).must_equal %w[LevelOne LevelOne/LevelTwo]
  end

  it '#has_parent?' do
    _(Mongoid::PathExtension.new('LevelOne/LevelTwo').has_parent?).must_equal true
    _(Mongoid::PathExtension.new('LevelOne').has_parent?).must_equal false
  end
end
