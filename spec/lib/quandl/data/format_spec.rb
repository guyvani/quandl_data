# encoding: utf-8
require 'spec_helper'

describe Quandl::Data::Format do
  
  expectations = [
    { 
      input:  "2013-12-05,10.03,11.0271,13.96623,19.1262\n2013-12-04,10.0760,11.0745,13.9777,19.2117",
      output: [[ Date.parse('2013-12-05'), 10.03, 11.0271, 13.96623, 19.1262 ], [ Date.parse('2013-12-04'), 10.0760, 11.0745, 13.9777, 19.2117 ]]
    },
  ]
  
  describe ".data" do
    expectations.each do |data|
      it "should recieve:\n#{data[:input].gsub(%Q{\n},'\n')} \n    and return:\n#{data[:output]}" do
        Quandl::Data::Format.parse(data[:input]).should eq data[:output]
      end
    end
  end
  
  subject{ Quandl::Data::Format }
  let(:escaped_csv){ '2444628,0.00385,0.001,0.123,0.00631,0.534\n2444627,0.00384,0.00159507,0.0056,0.00628948,0.009896' }
  let(:data_array){ [[ Date.jd(2444628),0.00385,0.001,0.123,0.00631,0.534], [ Date.jd(2444627),0.00384,0.00159507,0.0056,0.00628948,0.009896 ]] }

  let(:csv_data){ "#{Date.today}, 1.0, 2.0" }
  let(:hash_data){ { Date.today.to_s => [ 1.0, 2.0 ] } }
  let(:array_data){ [[ Date.today.to_s, 1.0, 2.0 ]] }
  let(:julian_data){ [[ Date.today.jd, 1.0, 2.0 ]] }
  let(:date_data){ [[ Date.today, 1.0, 2.0 ]] }
  
  it "#hash outputs array" do
    subject.hash_to_array( hash_data ).should eq array_data
  end
  
  describe "#parse" do
  
    [:csv, :hash, :array, :julian, :date].each do |type|
      context "#{type} data" do
        it "should eq date_data" do
          subject.parse( self.send("#{type}_data") ).should eq date_data
        end
        it "values should be_a Float" do
          subject.parse( self.send("#{type}_data") ).each{|r| r[1..-1].each{|v| v.should be_a Float } }
        end
      end
    end
  
  
    let(:csv1){ "2012-12-31,20.0,10.0,35.0,35.0,20.0,28.0,30.0,25.0,0.0,0.0,27.5,25.0,18.0,33.99,0.0,25.0,0.0,10.0,22.0,34.0,10.0,20.0,26.0,0.0,18.5,25.0,33.0,30.0,20.0,27.5,10.0,19.0,25.0,29.0,23.0,25.0,21.0,30.0,28.0,24.5,33.33,0.0,29.48,10.0,20.0,31.0,0.0,35.0,16.5,19.0,20.0,32.45,25.0,12.5,0.0,25.0,31.4,33.33,38.01,0.0,14.0,20.0,30.0,24.2,15.0,15.0,20.0,12.5,15.0,28.8,12.0,10.0,30.0,25.0,35.0,15.0,30.0,9.0,32.0,34.0,25.0,28.0,30.0,28.0,12.0,35.0,25.0,30.0,10.0,30.0,30.0,19.0,25.0,10.0,16.0,20.0,0.0,27.0,20.0,10.0,17.0,19.0,18.0,34.55,30.0,28.0,0.0,34.5,35.0,26.3,21.17,28.0,17.0,30.0,23.0,25.0,30.0,20.0,30.0,21.0,55.0,24.0,40.0,25.0,0.0,34.0,25.0,20.0,35.0,25.75,29.02,33.0,22.89,20.5,28.3,28.6,22.6,25.25,24.43\n2011-12-31,20.0,10.0,35.0,35.0,20.0,28.0,30.0,25.0,0.0,0.0,27.5,25.0,24.0,33.99,0.0,0.0,0.0,10.0,22.0,34.0,10.0,20.0,28.0,0.0,20.0,25.0,33.0,30.0,20.0,34.5,10.0,19.0,25.0,29.0,24.0,20.0,21.0,0.0,28.0,26.0,33.33,0.0,29.37,10.0,20.0,31.0,0.0,35.0,16.5,19.0,20.0,32.44,25.0,12.5,0.0,24.0,31.4,33.33,40.69,0.0,14.0,20.0,0.0,22.0,15.0,15.0,20.0,12.5,15.0,28.8,12.0,10.0,0.0,25.0,35.0,15.0,30.0,9.0,32.0,34.0,25.0,28.0,30.0,28.0,12.0,35.0,25.0,30.0,10.0,30.0,30.0,19.0,25.0,10.0,16.0,20.0,0.0,27.0,20.0,10.0,17.0,19.0,20.0,34.55,30.0,28.0,0.0,34.5,35.0,26.3,21.17,28.0,17.0,30.0,30.0,0.0,30.0,20.0,30.0,25.0,55.0,26.0,40.0,25.0,0.0,34.0,25.0,20.0,35.0,25.75,28.55,34.0,23.1,20.88,29.02,28.6,22.8,25.5,24.52\n2010-12-31,20.0,10.0,35.0,35.0,20.0,28.0,30.0,25.0,0.0,0.0,27.5,25.0,24.0,33.99,0.0,25.0,0.0,10.0,25.0,34.0,10.0,20.0,31.0,0.0,17.0,25.0,33.0,30.0,20.0,0.0,10.0,19.0,25.0,25.0,25.0,20.0,21.0,0.0,28.0,26.0,33.33,0.0,29.41,22.0,24.0,31.0,0.0,25.0,16.5,19.0,18.0,33.99,25.0,12.5,0.0,25.0,31.4,33.33,40.69,0.0,14.0,20.0,0.0,24.2,15.0,15.0,40.0,0.0,15.0,28.59,12.0,10.0,0.0,25.0,35.0,15.0,30.0,9.0,32.0,0.0,25.5,30.0,30.0,28.0,12.0,35.0,27.5,30.0,10.0,30.0,30.0,19.0,25.0,10.0,16.0,20.0,0.0,27.0,20.0,10.0,17.0,19.0,20.0,34.55,30.0,35.0,0.0,0.0,15.0,26.3,21.17,28.0,17.0,30.0,30.0,0.0,30.0,20.0,30.0,25.0,55.0,28.0,40.0,25.0,0.0,34.0,25.0,35.0,35.0,25.75,28.38,35.5,23.96,21.52,27.52,29.0,23.04,25.79,24.71\n2009-12-31,20.0,10.0,35.0,35.0,20.0,28.0,30.0,25.0,0.0,0.0,27.5,25.0,24.0,33.99,0.0,0.0,0.0,10.0,25.0,34.0,10.0,0.0,33.0,0.0,17.0,25.0,33.0,30.0,20.0,0.0,10.0,20.0,25.0,25.0,25.0,20.0,21.0,0.0,29.0,26.0,33.33,0.0,29.44,27.0,25.0,31.0,0.0,30.0,16.5,16.0,15.0,33.99,28.0,12.5,0.0,26.0,31.4,33.33,40.69,0.0,25.0,20.0,0.0,24.2,15.0,15.0,40.0,0.0,20.0,28.59,12.0,10.0,0.0,25.0,35.0,15.0,28.0,9.0,32.0,0.0,25.5,30.0,30.0,28.0,12.0,35.0,30.0,30.0,10.0,30.0,30.0,19.0,25.0,35.0,16.0,20.0,0.0,27.0,20.0,10.0,18.0,19.0,21.0,34.55,30.0,35.0,0.0,0.0,15.0,26.3,21.17,28.0,25.0,30.0,30.0,0.0,30.0,20.0,30.0,25.0,55.0,28.0,40.0,25.0,0.0,34.0,25.0,35.0,35.0,30.9,28.75,36.5,25.73,21.7,27.96,29.2,23.22,25.73,25.4\n2008-12-31,20.0,10.0,35.0,35.0,20.0,28.0,30.0,25.0,0.0,0.0,30.0,25.0,24.0,33.99,0.0,0.0,0.0,10.0,25.0,34.0,10.0,0.0,33.5,0.0,17.0,25.0,33.0,30.0,20.0,0.0,10.0,21.0,25.0,25.0,25.0,20.0,21.0,0.0,31.0,26.0,33.33,0.0,29.51,33.0,25.0,31.0,0.0,30.0,16.5,16.0,15.0,33.99,30.0,12.5,0.0,27.0,31.4,33.33,40.69,0.0,25.0,30.0,0.0,27.5,55.0,15.0,40.0,0.0,15.0,29.63,12.0,10.0,0.0,26.0,35.0,15.0,28.0,9.0,32.0,0.0,25.5,30.0,30.0,28.0,12.0,35.0,30.0,30.0,10.0,30.0,35.0,19.0,25.0,35.0,16.0,24.0,0.0,27.0,20.0,10.0,18.0,19.0,22.0,34.55,30.0,35.0,0.0,0.0,15.0,28.0,21.17,28.0,25.0,0.0,30.0,0.0,30.0,20.0,30.0,25.0,55.0,30.0,40.0,25.0,0.0,34.0,28.0,35.0,35.0,30.9,28.65,36.75,27.99,22.0,27.96,29.6,23.29,26.08,26.12\n2007-12-31,20.0,20.0,35.0,35.0,20.0,28.0,30.0,25.0,0.0,0.0,30.0,25.0,24.0,33.99,0.0,0.0,0.0,10.0,25.0,34.0,10.0,0.0,36.1,0.0,17.0,33.0,34.0,30.0,20.0,0.0,10.0,24.0,25.0,25.0,25.0,20.0,22.0,0.0,31.0,26.0,33.33,0.0,38.36,35.0,25.0,31.0,0.0,30.0,17.5,16.0,18.0,33.99,30.0,12.5,0.0,29.0,37.25,33.33,40.69,0.0,25.0,30.0,0.0,27.5,55.0,15.0,40.0,0.0,15.0,29.63,12.0,12.0,0.0,27.0,35.0,22.5,28.0,9.0,32.0,0.0,25.5,33.0,30.0,28.0,12.0,35.0,30.0,30.0,10.0,30.0,35.0,19.0,25.0,35.0,16.0,24.0,0.0,27.0,20.0,10.0,20.0,19.0,23.0,36.89,32.5,35.0,0.0,0.0,30.0,28.0,21.32,28.0,25.0,0.0,30.0,0.0,30.0,20.0,30.0,25.0,55.0,30.0,40.0,30.0,0.0,34.0,28.0,35.0,35.0,30.9,30.56,38.05,28.46,23.01,28.3,30.2,24.11,27.08,26.96\n"}
    let(:csv2){ "2012-03-07,,69.75,69.75,69.75,0.0,0.0,0.0\n2012-03-06,69.75,69.75,69.75,69.75,0.0,0.0,0.0\n2012-03-05,69.75,69.75,69.75,69.75,0.0,0.0,0.0\n2012-03-04,69.75,69.75,69.75,69.75,0.0,0.0,0.0\n2012-02-29,,69.75,69.75,69.75,0.0,0.0,0.0\n2012-02-28,69.75,69.75,69.75,69.75,0.0,0.0,0.0\n" }

    [:csv1, :csv2].each do |type|
      context "#{type} data" do
        it "dates should be_a Date" do
          subject.parse( self.send(type) ).each{|r| r[0].should be_a Date }
        end
        
        it "values should be_a Float" do
          subject.parse( self.send(type) ).each do |row|
            row[1..-1].each do |value|
              next if value.nil?
              value.should be_a Float
            end
          end
        end
        
      end
    end
  
    let(:invalid1){ "Date, Column 1, Column 2, C3, C4, C5, C6, C7\n 2012-03-07,,69.75,69.75,69.75,0.0,0.0,0.0\n2012-03-06,69.75,69.75,69.75,69.75,0.0,0.0,0.0\n2012-03-05,69.75,69.75,69.75,69.75,0.0,0.0,0.0\n2012-03-04,69.75,69.75,69.75,69.75,0.0,0.0,0.0\n2012-02-29,,69.75,69.75,69.75,0.0,0.0,0.0\n2012-02-28,69.75,69.75,69.75,69.75,0.0,0.0,0.0\n" }
    let(:invalid2){ "2012-03-07,,69.75,69.75,69.75,0.0,0.0,0.0\nDate, Column 1, Column 2, C3, C4, C5, C6, C7\n2012-03-06,69.75,69.75,69.75,69.75,0.0,0.0,0.0\n2012-03-05,69.75,69.75,69.75,69.75,0.0,0.0,0.0\n2012-03-04,69.75,69.75,69.75,69.75,0.0,0.0,0.0\n2012-02-29,,69.75,69.75,69.75,0.0,0.0,0.0\n2012-02-28,69.75,69.75,69.75,69.75,0.0,0.0,0.0\n" }
    
    [:invalid1, :invalid2].each do |type|
      it "#{type} should raise Quandl::Error::UnknownDateFormat" do
        expect {  Quandl::Data::Format.parse( self.send(type) ) }.to raise_error Quandl::Error::DateParseError
      end
    end
    
  end
  
end