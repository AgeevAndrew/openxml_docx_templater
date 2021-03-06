# frozen_string_literal: true

require 'spec_helper'

RSpec.describe String do
  let(:string) { '<w:t>&</w:t>' }
  describe '#escape_xml' do
    subject { string.escape_xml }

    it do
      should eq '&lt;w:t&gt;&amp;&lt;/w:t&gt;'
    end
  end

  describe '#refact' do
    subject { string.refact }

    let(:expression) do
      '<w:t>{</w:t><w:r><w:r><w:t>%= </w:t><w:t>some expressions</w:t><w:t> %}</w:t>'
    end
    let(:string) { expression }
    let(:result) { '<w:t>{%= some expressions %}</w:t>' }

    it { should eq result }

    context 'with brakets' do
      let(:string) { '<w:t>{{%= </w:t><w:t>some expressions </w:t><w:t>%}</w:t><w:t>}</w:t>' }
      let(:result) { '<w:t>{{%= some expressions %}</w:t><w:t>}</w:t>' }

      it { should eq result }
    end

    context 'when image is nearby' do
      let(:picture) { '<a:ext uri="{28A0092B-C50C-407E-A947-70E740481C1C}"><other tags>' }
      let(:string) { [picture, expression].join }

      it { should eq [picture, result].join }
    end
  end

  describe '#convert_newlines' do
    subject { string.convert_newlines }

    context 'string has new lines' do
      let(:string) do
        <<~HEREDOC
          One Line
          Two Line
          Three Line
        HEREDOC
      end

      it { should eq 'One Line<w:br/>Two Line<w:br/>Three Line<w:br/>' }
    end

    context 'string has no new lines' do
      let(:string) { 'One Two Three' }

      it { should eq string }
    end
  end
end
