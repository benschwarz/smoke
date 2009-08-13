require "rubygems"
require "open3"

require "contest"

require "pp"
require "stringio"
require "fileutils"

$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

class Dep
  # Override exit to allow the tests to keep running.
  def exit(*attrs)
  end
end

class DependenciesTest < Test::Unit::TestCase
  def do_require
    load "dependencies.rb"
  end

  def ensure_gem_home
    gem_path = File.expand_path(File.join(File.dirname(__FILE__), "..", "tmp"))

    flunk "GEM_HOME should be #{gem_path}. Run with env GEM_HOME=#{gem_path}." unless gem_path == ENV["GEM_HOME"]
  end

  def with_dependencies(deps)
    File.open("dependencies", "w") do |f|
      f.write(deps)
    end

    yield
  ensure
    FileUtils.rm("dependencies")
  end

  context "lib" do
    setup do
      @load_path = $LOAD_PATH.dup
    end

    test "loads dependencies from ./vendor" do
      with_dependencies "bar" do
        do_require
        assert_equal File.expand_path("vendor/bar/lib"), $:[1]
      end

      with_dependencies "bar 1.0" do
        do_require
        assert_equal File.expand_path("vendor/bar/lib"), $:[1]
      end
    end

    test "honors the version number for the vendor directory" do
      with_dependencies "foo 2.0" do
        do_require
        assert_equal File.expand_path("vendor/foo-2.0/lib"), $:[1]
      end
    end

    test "add ./lib to the load path" do
      with_dependencies "" do
        do_require
        assert_equal File.expand_path("lib"), $:.first
      end
    end

    test "alert about missing dependencies" do
      with_dependencies "foo 1.0" do
        err = capture_stderr do
          do_require
        end

        assert err.include?("Missing dependencies:\n\n  foo 1.0")
        assert err.include?("Run `dep list` to view missing dependencies or `dep vendor --all` if you want to vendor them.")
      end
    end

    test "load environment-specific dependencies" do
      begin
        ENV["RACK_ENV"] = "integration"

        with_dependencies "bar\nbarz 2.0 (test)\nbaz 1.0 (integration)" do
          do_require

          assert $:.include?(File.expand_path("vendor/bar/lib"))
          assert $:.include?(File.expand_path("vendor/baz-1.0/lib"))
          assert !$:.include?(File.expand_path("vendor/barz-2.0/lib"))
        end

      ensure
        ENV.delete "RACK_ENV"
      end
    end

    teardown do
      $LOAD_PATH.replace(@load_path)
    end
  end

  context "binary" do
    def dep(args = nil)
      out, err = nil

      Open3.popen3("#{File.expand_path(File.join("../bin/dep"))} #{args}") do |stdin, stdout, stderr|
        out = stdout.read
        err = stderr.read
      end

      [out, err]
    end

    context "list" do
      test "prints all dependencies" do
        with_dependencies "foo ~> 1.0\nbar" do
          out, err = dep "list"
          assert_equal "foo ~> 1.0\nbar\n", out
        end
      end

      test "prints dependencies based on given environment" do
        with_dependencies "foo 1.0 (test)\nbar (development)\nbarz 2.0\nbaz 0.1 (test)" do
          out, err = dep "list test"
          assert_equal "foo 1.0 (test)\nbarz 2.0\nbaz 0.1 (test)\n", out
        end
      end

      test "complains when no dependencies file found" do
        out, err = dep "list"
        assert_equal "No dependencies file found.\n", err
      end
    end

    context "vendor" do
      setup do
        @dir = create_repo("foobar")
      end

      test "vendors dependencies" do
        with_dependencies "foobar file://#{@dir}" do
          out, err = dep "vendor foobar"

          assert File.exist?("vendor/foobar/lib/foobar.rb")
          assert !File.exist?("vendor/foobar/.git")
        end
      end

      test "vendors using RubyGems when given a version" do
        ensure_gem_home

        system "gem install foobaz-0.3.gem > /dev/null"

        with_dependencies "foobaz 0.3" do
          out, err = dep "vendor foobaz"

          assert  File.exist?("vendor/foobaz-0.3/lib/foobaz.rb")
          assert !File.exist?("vendor/foobaz-0.3/.git")
        end
      end

      test "complains when no URL given" do
        with_dependencies "foobar" do
          out, err = dep "vendor foobar"

          assert_match %r{Don't know where to vendor foobar from \(no version or URL given...\)}, err
        end
      end

      test "complains when the dependency is not found" do
        with_dependencies "foobar 1.0" do
          out, err = dep "vendor qux"

          assert_match %r{Dependency qux not found.}, err
        end
      end

      test "vendors everything with --all" do
        with_dependencies "foobar file://#{@dir}\nbarbar file://#{create_repo "barbar"}" do
          out, err = dep "vendor --all"

          assert File.exist?("vendor/foobar/lib/foobar.rb")
          assert !File.exist?("vendor/foobar/.git")

          assert File.exist?("vendor/barbar/lib/barbar.rb")
          assert !File.exist?("vendor/barbar/.git")
        end
      end

      teardown do
        FileUtils.rm_rf(@dir)
      end

      def create_repo(name)
        dir = File.expand_path(File.join(File.dirname(__FILE__), "tmp", name))

        FileUtils.rm_rf(dir)
        FileUtils.rm_rf("vendor/#{name}")
        FileUtils.mkdir_p(dir)

        Dir.chdir(dir) do
          `git init`

          FileUtils.mkdir("lib")
          FileUtils.touch("lib/#{name}.rb")

          `git add lib`
          `git commit -m 'Lorem.'`
        end

        dir
      end
    end
  end

protected

  def capture_stderr
    begin
      err, $stderr = $stderr, StringIO.new
      yield
    ensure
      $stderr, err = err, $stderr
    end
    err.string
  end
end
