class MyApp
  def call(_env)
    [
      200,
      { "Content-Type" => "text/html" },
      ["Hello Rack app!"]
    ]
  end
end

MyAppWrapped = Rack::Builder.new do |builder|
  builder.use Rack::Session::Cookie, :secret => "Very secret secret"
  builder.run MyApp.new
end
