require 'spec_helper'

describe 'autofs::mapfile' do
  let(:title) { 'auto.foo' }
  let(:facts) {{ :osfamily => 'RedHat', :concat_basedir => '/mock_dir' }}

  describe 'passing something other than present, absent, or purged for ensure' do
      let(:params) {{ :directory => '/foo' , :ensure => 'foo' }}
      it { should raise_error(Puppet::Error, /ensure must be one of/) }
  end

  describe 'passing present for ensure' do
      let(:params) {{ :directory => '/foo' , :ensure => 'present' }}
      it { should_not raise_error }
      it {
          should contain_concat__fragment('auto.master/auto.foo').
          with_content(/\/foo auto.foo/)
      }
      it {
          should contain_concat('auto.foo').
          with_ensure('present')
      }
  end

  describe 'passing absent for ensure' do
      let(:params) {{ :directory => '/foo' , :ensure => 'absent' }}
      it { should_not raise_error }
      it {
          should_not contain_concat__fragment('auto.master/auto.foo')
      }
      it {
          should contain_concat('auto.foo').
          with_ensure('absent')
      }
  end

  describe 'passing purged for ensure' do
      let(:params) {{ :directory => '/foo' , :ensure => 'purged' }}
      it { should_not raise_error }
      it {
          should_not contain_concat__fragment('auto.master/auto.foo')
      }
      it {
          should contain_concat('auto.foo').
          with_ensure('absent')
      }
      it {
          should contain_file('/foo').
          with({
              'ensure' => 'absent',
              'force'  => true,
          })
      }
  end

  describe 'with an invalid map type' do
      let(:params) {{ :directory => '/foo' , :maptype => 'bar' }}
      it { should raise_error(Puppet::Error, /maptype must be one of/) }
  end

  describe 'with a different map type' do
      let(:params) {{ :directory => '/foo' , :maptype => 'program' }}
      it { should_not raise_error }
      it {
          should contain_concat__fragment('auto.master/auto.foo').
          with_content(/program:auto.foo/)
      }
      it {
          should_not contain_concat('auto.foo')
      }
  end

end

