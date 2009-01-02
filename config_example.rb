Sinatra.application.set :host => "72.232.60.53" if Object.const_defined? "Sinatra"
DataMapper.setup(:default, "mysql://wed:s9m2b3c5z6@localhost/isthisnovel") if Object.const_defined? "DataMapper"
