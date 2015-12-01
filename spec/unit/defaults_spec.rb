require "spec_helper"

module Vault
  describe Defaults do
    describe ".options" do
      it "returns a hash" do
        expect(Defaults.options).to be_a(Hash)
      end
    end

    describe ".address" do
      it "uses ENV['VAULT_ADDR'] if present" do
        with_stubbed_env("VAULT_ADDR" => "test") do
          expect(Defaults.address).to eq("test")
        end
      end

      it "falls back to the default VAULT_ADDRESS" do
        with_stubbed_env("VAULT_ADDR" => nil) do
          expect(Defaults.address).to eq(Defaults::VAULT_ADDRESS)
        end
      end
    end

    describe ".token" do
      let(:token) { File.expand_path("~/.vault-token") }
      let(:backup_token) { File.expand_path("~/.vault-token.old") }

      before do
        if File.exist?(token)
          FileUtils.mv(token, backup_token)
        end
      end

      after do
        if File.exist?(backup_token)
          FileUtils.mv(backup_token, token)
        end
      end

      it "uses ~/.vault-token when present" do
        File.open(token, "w") { |f| f.write("testing") }
        expect(Defaults.token).to eq("testing")
      end

      it "uses ENV['VAULT_TOKEN'] if present" do
        with_stubbed_env("VAULT_TOKEN" => "testing") do
          expect(Defaults.token).to eq("testing")
        end
      end

      it "prefers the local token over the environment" do
        File.open(token, "w") { |f| f.write("testing1") }
        with_stubbed_env("VAULT_TOKEN" => "testing2") do
          expect(Defaults.token).to eq("testing1")
        end
      end
    end

    describe ".open_timeout" do
      it "defaults to ENV['VAULT_OPEN_TIMEOUT']" do
        with_stubbed_env("VAULT_OPEN_TIMEOUT" => "30") do
          expect(Defaults.open_timeout).to eq("30")
        end
      end
    end

    describe ".proxy_address" do
      it "defaults to ENV['VAULT_PROXY_ADDRESS']" do
        with_stubbed_env("VAULT_PROXY_ADDRESS" => "30") do
          expect(Defaults.proxy_address).to eq("30")
        end
      end
    end

    describe ".proxy_username" do
      it "defaults to ENV['VAULT_PROXY_USERNAME']" do
        with_stubbed_env("VAULT_PROXY_USERNAME" => "30") do
          expect(Defaults.proxy_username).to eq("30")
        end
      end
    end

    describe ".proxy_password" do
      it "defaults to ENV['VAULT_PROXY_PASSWORD']" do
        with_stubbed_env("VAULT_PROXY_PASSWORD" => "30") do
          expect(Defaults.proxy_password).to eq("30")
        end
      end
    end

    describe ".proxy_port" do
      it "defaults to ENV['VAULT_PROXY_PORT']" do
        with_stubbed_env("VAULT_PROXY_PORT" => "30") do
          expect(Defaults.proxy_port).to eq("30")
        end
      end
    end

    describe ".read_timeout" do
      it "defaults to ENV['VAULT_READ_TIMEOUT']" do
        with_stubbed_env("VAULT_READ_TIMEOUT" => "30") do
          expect(Defaults.read_timeout).to eq("30")
        end
      end
    end

    describe ".retry_attempts" do
      it "defaults to ENV['VAULT_RETRY_ATTEMPTS']" do
        with_stubbed_env("VAULT_RETRY_ATTEMPTS" => "30") do
          expect(Defaults.retry_attempts).to eq(30)
        end
      end

      it "falls back to default 0" do
        with_stubbed_env("VAULT_RETRY_ATTEMPTS" => nil) do
          expect(Defaults.retry_attempts).to eq(1)
        end
      end
    end

    describe ".retry_base" do
      it "defaults to ENV['VAULT_RETRY_BASE']" do
        with_stubbed_env("VAULT_RETRY_BASE" => "30") do
          expect(Defaults.retry_base).to eq(30)
        end
      end

      it "falls back to default RETRY_BASE" do
        with_stubbed_env("VAULT_RETRY_BASE" => nil) do
          expect(Defaults.retry_base).to eq(0.05)
        end
      end
    end

    describe ".retry_max_wait" do
      it "defaults to ENV['VAULT_RETRY_MAX_WAIT']" do
        with_stubbed_env("VAULT_RETRY_MAX_WAIT" => "30") do
          expect(Defaults.retry_max_wait).to eq(30)
        end
      end

      it "falls back to default RETRY_MAX_WAIT" do
        with_stubbed_env("VAULT_RETRY_MAX_WAIT" => nil) do
          expect(Defaults.retry_max_wait).to eq(2.0)
        end
      end
    end

    describe ".ssl_ciphers" do
      it "defaults to ENV['VAULT_SSL_CIPHERS']" do
        with_stubbed_env("VAULT_SSL_CIPHERS" => "testing") do
          expect(Defaults.ssl_ciphers).to eq("testing")
        end
      end

      it "falls back to the default SSL_CIPHERS" do
        with_stubbed_env("VAULT_SSL_CIPHERS" => nil) do
          expect(Defaults.ssl_ciphers).to eq(Defaults::SSL_CIPHERS)
        end
      end
    end

    describe ".ssl_pem_file" do
      it "defaults to ENV['VAULT_SSL_CERT']" do
        with_stubbed_env("VAULT_SSL_CERT" => "~/path/to/cert") do
          expect(Defaults.ssl_pem_file).to eq("~/path/to/cert")
        end
      end
    end

    describe ".ssl_pem_passphrase" do
      it "defaults to ENV['VAULT_SSL_CERT_PASSPHRASE']" do
        with_stubbed_env("VAULT_SSL_CERT_PASSPHRASE" => "testing") do
          expect(Defaults.ssl_pem_passphrase).to eq("testing")
        end
      end
    end

    describe ".ssl_ca_cert" do
      it "defaults to ENV['VAULT_CACERT']" do
        with_stubbed_env("VAULT_CACERT" => "~/path/to/cert") do
          expect(Defaults.ssl_ca_cert).to eq("~/path/to/cert")
        end
      end
    end

    describe ".ssl_ca_path" do
      it "defaults to ENV['VAULT_CAPATH']" do
        with_stubbed_env("VAULT_CAPATH" => "~/path/to/cert") do
          expect(Defaults.ssl_ca_path).to eq("~/path/to/cert")
        end
      end
    end

    describe ".ssl_verify" do
      it "defaults to true" do
        expect(Defaults.ssl_verify).to be(true)
      end

      it "reads the value of ENV['VAULT_SSL_VERIFY']" do
        with_stubbed_env("VAULT_SSL_VERIFY" => false) do
          expect(Defaults.ssl_verify).to be(false)
        end
      end
    end

    describe ".ssl_timeout" do
      it "defaults to ENV['VAULT_SSL_TIMEOUT']" do
        with_stubbed_env("VAULT_SSL_TIMEOUT" => "30") do
          expect(Defaults.ssl_timeout).to eq("30")
        end
      end
    end

    describe ".timeout" do
      it "defaults to ENV['VAULT_TIMEOUT']" do
        with_stubbed_env("VAULT_TIMEOUT" => "30") do
          expect(Defaults.timeout).to eq("30")
        end
      end
    end
  end
end
