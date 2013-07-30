module Sinatra
  module Chiro
    class Documentation

      attr_reader :endpoints

      def initialize(endpoints)
        @endpoints = endpoints
      end

      def show(env)
        _, url = env['sinatra.route'].split('/')
        path_array = env['sinatra.route'].split('/')[1..-1]
        endpoint = endpoints.select { |d| d.path.split('/')[1..-1] == path_array}.flatten.first
        raise "Path #{url} doesn't have any docs" unless endpoint

        p endpoint.path.split('/')[1..-1]
        p path_array

        response_body = endpoint.to_json

        return response_body
      end

      def description(env)
        _, url = env['sinatra.route'].split('/')
        endpoint = endpoints.select { |d| d.path.include?(url) }.flatten.first
        endpoint.description
      end

      def post(env)
        _, url = env['sinatra.route'].split('/')
        endpoint = endpoints.select { |d| d.path.include?(url) }.flatten.first
        endpoint.verb
      end

      def path(env)
        _, url = env['sinatra.route'].split('/')
        endpoint = endpoints.select { |d| d.path.include?(url) }.flatten.first
        endpoint.path
      end

      def named(env)
        _, url = env['sinatra.route'].split('/')
        endpoint = endpoints.select { |d| d.path.include?(url) }.flatten.first
        string = String.new
        endpoint.named_params.each do |hash|
          hash.each do |k, v|
            string << "#{k.to_s}: #{v.to_s}<br>"
          end
          string << "<br>"
        end
        return string
      end

      def query(env)
        _, url = env['sinatra.route'].split('/')
        endpoint = endpoints.select { |d| d.path.include?(url) }.flatten.first
        string = String.new
        endpoint.query_params.each do |hash|
          hash.each do |k, v|
            string << "#{k.to_s}: #{v.to_s}<br>"
          end
          string << "<br>"
        end
        return string
      end

      def form(env)
        _, url = env['sinatra.route'].split('/')
        endpoint = endpoints.select { |d| d.path.include?(url) }.flatten.first
        string = String.new
        endpoint.forms.each do |hash|
          hash.each do |k, v|
            string << "#{k.to_s}: #{v.to_s}<br>"
          end
          string << "<br>"
        end
        return string
      end


    end
  end
end

