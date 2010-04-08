module WatirPatches
	def self.patch!
    Watir::Element.subclasses.each do|e|
      WatirPatches::LocatePatch.patch_if(e.constantize)
    end

    Watir::Element.send :include, WatirPatches::ElementMethods
  end
	module ElementMethods
		def self.included(base)
			base.extend ClassMethod
			base.send :include, InstanceMethod
		end
		
		module ClassMethod
			def by_type(tag_type)
        assert tag_type
        tag_type.downcase!
        if tag_type=="a"
           tag_type = "link"
        end
				"Watir::#{tag_type.classify}".constantize
			end
		end
		
		module InstanceMethod
		end
	end
	
	module LocatePatch
		
		def self.included(base)
			base.class_eval do
				alias_method_chain :locate, :ole_object
			end
		end
		
		def self.patch_if(clazz)
			if clazz.instance_methods.include? "locate"
				clazz.send :include, WatirPatches::LocatePatch
				true
			else
				false
			end
			
		end
		
		def locate_with_ole_object
			@o = if @how == :ole_object
				@what
			else
				locate_without_ole_object
			end
		end
	end
end


if $0==__FILE__
	require "test/unit"
	require 'active_support'
	class NotPatchedMockElement
		def	method_1
		end
	end

	class PatchedMockElement
		def initialize
			@how = :ole_object
			@what = true
		end
		
		def locate
			return false
		end
	end


	class NotOlePatchedMockElement
		attr_accessor :how,:what
		def initialize
			@how = :xpath
			@what = true
		end
		
		def locate
			return false
		end
  end

  class PatchTest < Test::Unit::TestCase
		def test_patch_if
			assert_equal WatirPatches::LocatePatch.patch_if(NotPatchedMockElement), false
			assert WatirPatches::LocatePatch.patch_if(PatchedMockElement), true
			assert WatirPatches::LocatePatch.patch_if(NotOlePatchedMockElement), true
		end
		
		def test_patch
			assert_equal PatchedMockElement.new.locate, false
			WatirPatches::LocatePatch.patch_if(PatchedMockElement)
			assert_equal PatchedMockElement.new.locate, true
		end

		def test_not_ole
			assert_equal NotOlePatchedMockElement.new.locate, false
			WatirPatches::LocatePatch.patch_if(NotOlePatchedMockElement)
			assert_equal NotOlePatchedMockElement.new.locate, false
		end

	end

	
end