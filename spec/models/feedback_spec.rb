require 'spec_helper'

describe Feedback do

	let!(:feedback) { Feedback.create(:name => "test feedback") }

	subject { feedback }

	it { should respond_to(:id) }
	it { should respond_to(:name) }

end
