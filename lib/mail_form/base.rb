module MailForm
	class Base
		include ActiveModel::AttributeMethods # 1. Include attribute methods from active model
		include ActiveModel::Conversion 
		extend ActiveModel::Naming # Adds methods like singular, human, model_name
		extend ActiveModel::Translation # Adds localization methods
		include ActiveModel::Validations # Provides errors, valid?, and validates methods

		attribute_method_prefix 'clear_' # 2. clear_ will be attribute prefix
		attribute_method_suffix '?'

		class_attribute :attribute_names
		self.attribute_names = []

		def self.attributes(*names)
			attr_accessor(*names)

			# 3. Ask to define the prefix and suffix methods for the given attribute names
			define_attribute_methods(names)

			self.attribute_names += names
		end

		def persisted?
			false
		end

		def deliver
			if valid?
				MailForm::Notifier.contact(self).deliver
			else
				false
			end
		end

		def headers
			{ to: "recipient@example.com", from: self.email }
		end

		protected

		# 4. Since we declared a "clear_" prefix, it expects to have a clear attribute method defined.
		# It receives an attribute name and implements the clearing logic
		def clear_attribute(attribute)
			send("#{attribute}=", nil)
		end

		def attribute?(attribute)
			send(attribute).present?
		end
	end
end

# ActiveModel::AttributeMethods uses method_missing() to compile both the clear_name, clear_email, name?, email? methods when they are first accessed
# Their implementation invokes clear_attribute which passes in the attribute from method_missing