# frozen_string_literal: true

# Cloud Foundry Java Buildpack
# Copyright 2013-2018 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'fileutils'
require 'java_buildpack/component/versioned_dependency_component'
require 'java_buildpack/framework'
require 'java_buildpack/util/cache/internet_availability'
require 'java_buildpack/util/to_b'
require 'json'

module JavaBuildpack
  module Framework

    # Encapsulates the functionality for enabling zero-touch Dynatrace SaaS/Managed support.
    class PinpointAgent < JavaBuildpack::Component::VersionedDependencyComponent

      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        download_zip(false, @droplet.sandbox, 'Pinpoint Agent')

        #JavaBuildpack::Util::Cache::InternetAvailability.instance.available(
        #  true, 'The Pinpoint Agent download location is always accessible'
        #) do
        #   FileUtils.mkdir @droplet.sandbox.relative_path_from(@droplet.root)
        #  download(@version, @uri) { |file| expand file }
        #end

        @droplet.copy_resources
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release
       
        #@droplet.java_opts.add_javaagent(@droplet.sandbox + "pinpoint-bootstrap-1.7.4-SNAPSHOT.jar")

      end

      protected

      # (see JavaBuildpack::Component::VersionedDependencyComponent#supports?)
      def supports?
        @application.services.one_service? FILTER
      end

      private

      PINPOINT_AGENTID = 'agentId'

      PINPOINT_APPLICATIONNAME = 'applicationName'

      PINPOINT_PROFILER_COLLECTOR_IP = 'collectorIp'

      PINPOINT_PROFILER_COLLECTOR_TCP_PORT = 'collectorTcpPort'

      PINPOINT_PROFILER_COLLECTOR_STAT_PORT = 'collectorStatPort'

      PINPOINT_PROFILER_COLLECTOR_SPAN_PORT = 'collectorSpanPort'

      FILTER = /pinpoint/


      private_constant :PINPOINT_AGENTID, :PINPOINT_APPLICATIONNAME, :PINPOINT_PROFILER_COLLECTOR_IP, 
                       :PINPOINT_PROFILER_COLLECTOR_TCP_PORT, :PINPOINT_PROFILER_COLLECTOR_STAT_PORT,
                       :PINPOINT_PROFILER_COLLECTOR_SPAN_PORT, :FILTER

    

      def expand(file)
        with_timing "1 Expanding PinpointAgent to #{@droplet.sandbox.relative_path_from(@droplet.root)}" do
          Dir.mktmpdir do |root|
            root_path = Pathname.new(root)
            #shell "unzip -qq #{file.path} -d #{root_path} 2>&1"
            shell "unzip -qq #{file.path} -d #{root_path}"
            shell "pwd && ls -al"

            unpack_agent root_path
            shell "pwd && ls -al"
          end
        end
      end

      def unpack_agent(root)
        FileUtils.mkdir_p(@droplet.sandbox)
        FileUtils.mv(root + 'agent', @droplet.sandbox)
      
      end

    end

  end
end
