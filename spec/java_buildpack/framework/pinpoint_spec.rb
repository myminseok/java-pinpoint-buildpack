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

require 'spec_helper'
require 'component_helper'
require 'java_buildpack/framework/pinpoint_agent'
require 'java_buildpack/util/tokenized_version'

describe JavaBuildpack::Framework::PinpointAgent do
  include_context 'with component help'

  it 'does not detect without pinpoint-n/a service' do
    expect(component.detect).to be_nil
  end

  context do

    before do
     allow(services).to receive(:one_service?).with(/pinpoint/, 'uri').and_return(true)
    end

    it 'detects with dynatrace-n/a service' do
      expect(component.detect).to eq('dynatrace-one-agent=latest')
    end

    it 'downloads pinpoint agent zip',
       cache_fixture: 'pinpoint-agent-1.7.4-SNAPSHOT.zip' do

      component.compile

      expect(sandbox + 'pinpoint-bootstrap-1.7.4-SNAPSHOT.jar').to exist
    end

    it 'updates JAVA_OPTS with agent loader',
       app_fixture: 'framework_pinpoint_agent' do

      component.release
      expect(java_opts).to include('-javaagent:$PWD/.java-buildpack/pinpoint_agent/pinpoint-bootstrap-1.7.4-SNAPSHOT.jar1' )
    end


  end

end
