require "spec_helper"

describe MoviesHelper do
    describe "#oddness" do
        it "should return true if the number is odd" do
            helper.oddness(2).should be_true
        end
        it "should return false if the number is not odd" do
            helper.oddness(5).should be_false
        end
    end
end
