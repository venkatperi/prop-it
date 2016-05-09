module.exports = ( obj, opts ) ->
  throw new Error( "missing option: obj" ) unless obj?
  opts = {} unless opts?
  name = opts.name or throw new Error( "missing option: name" )
  throw new Error "member exists: #{name}" if obj[ name ]?

  store = opts.store or obj
  throw new Error "bad store"  unless store?
  field = opts.field or if store is obj then "_#{name}" else name
  convert = opts.convert
  getter = opts.getter or -> store[ field ]
  setter = opts.setter or ( v ) ->
    store[ field ] = if convert? then convert v else v

  setter opts.initial if opts.initial?

  obj[ name ] = ( value ) ->
    v = getter()
    return v if arguments.length is 0 or opts.readOnly
    if v != value
      setter value
      obj.emit "changed:#{name}", value, v if obj.emit?
    obj
