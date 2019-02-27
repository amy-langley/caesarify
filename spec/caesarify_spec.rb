require 'rspec'
require '../caesarify/app/caesarify'

describe Caesarify::App do
  it 'loads the config' do
    app = described_class.new workflow_id: 1234

    expect(app.caesar_url).not_to be_nil
    expect(app.panoptes_url).not_to be_nil
    expect(app.workflow_id).not_to be_nil
  end

  it 'does the thing' do
    app = described_class.new workflow_id: 3085
    app.go
  end
end