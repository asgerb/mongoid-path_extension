require 'test_helper'

class PathExtensionTest
  include Mongoid::Document
  field :path, type: Mongoid::PathExtension
end

describe Mongoid::PathExtension do
  let(:path) { 'LevelOne/LevelTwo/LevelThree' }
  subject { PathExtensionTest.new(path: path) }

  it 'preserves it' do
    subject.path.must_equal path
  end

  it '#components' do
    subject.path.components.must_equal %w(LevelOne LevelTwo LevelThree)
  end

  it '#absolute' do
    subject.path.absolute.must_equal "/#{path}"
  end

  it '#root' do
    subject.path.root.must_equal 'LevelOne'
  end

  it '#permalink' do
    subject.path.permalink.must_equal 'LevelThree'
  end

  it '#parent_path' do
    subject.path.parent_path.must_equal 'LevelOne/LevelTwo'
  end

  it '#parent_permalink' do
    subject.path.parent_permalink.must_equal 'LevelTwo'
  end

  it '#ancestor_paths' do
    subject.path.ancestor_paths.must_equal %w[LevelOne LevelOne/LevelTwo]
  end

  it '#has_parent?' do
    Mongoid::PathExtension.new('LevelOne/LevelTwo').has_parent?.must_equal true
    Mongoid::PathExtension.new('LevelOne').has_parent?.must_equal false
  end
end
