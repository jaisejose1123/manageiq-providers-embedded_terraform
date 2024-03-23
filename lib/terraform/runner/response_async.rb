module Terraform
  class Runner
    class ResponseAsync
      include Vmdb::Logging

      # Response object designed for holding full response from terraform-runner stack job
      #
      # @param stack_id [String] terraform-runner stack job - stack_id
      def initialize(stack_id)
        @stack_id = stack_id
      end

      # @return [Boolean] true if the terraform stack job is still running, false when it's finished
      def running?
        return (@response.status == "" || @response.status == "IN_PROGRESS") if @response

        false
      end

      # Stops the running Terraform job
      def stop
        raise Error, "Not yet running" if !running?

        Terraform::Runner.stop_async(@response.stack_id)
      end

      # Re-Fetch async job's response
      def refresh_response
        @response = Terraform::Runner.fetch_result_by_stack_id(@stack_id)

        @response
      end

      # @return [Terraform::Runner::Response, NilClass] Response object with all details about the Terraform run, or nil
      #         if the Terraform is still running
      def response
        # return if running?
        return @response if @response

        @response = Terraform::Runner.fetch_result_by_stack_id(@stack_id)

        @response
      end
    end
  end
end
